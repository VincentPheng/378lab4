extends CharacterBody2D
class_name Player

@onready var book_scn = preload("res://instances/book.tscn")
@onready var stapler_scn = preload("res://instances/stapler.tscn")
@onready var pencils_scn = preload("res://instances/pencils.tscn")
@onready var ruler_scn = preload("res://instances/ruler.tscn")
@onready var triangle_ruler_scn = preload("res://instances/triangle_ruler.tscn")
@onready var eraser_scn = preload("res://instances/eraser.tscn")
@onready var sharpener_scn = preload("res://instances/sharpener.tscn")
@onready var tape_scn = preload("res://instances/tape.tscn")
@onready var scissors_scn = preload("res://instances/scissors.tscn")
@onready var calculator_scn = preload("res://instances/calculator.tscn")
@onready var glue_scn = preload("res://instances/glue.tscn")
@onready var trophy_scn = preload("res://instances/trophy.tscn")

@onready var table_scn = preload("res://instances/table.tscn")
@onready var table_sprite = preload("res://sprites/table.png")
@onready var lightning_scn = preload("res://instances/lightning_effect.tscn")
@onready var rumble_scn = preload("res://instances/bass_rumble.tscn")

@export var SPEED := 300.0
@export var baseHealth := 100
@export var baseStamina := 100
@export var sprintSpeedMultiplier := 1.5

@onready var player_camera: PlayerCamera = get_tree().current_scene.get_node("PlayerCamera")

var projectiles
var hud: HUD
var projectile_spawns
var holding := ""
var level: Level
var currSpeedMultipler := 1.0
var invincible := false
var currStamina := baseStamina
var currHealth := baseHealth
var talking := false
var curr_objective
var riffs: Array[Node]
var can_autothrow = true

func _ready():
	$LightningTimer.wait_time = PlayerData.shock_cooldown
	currHealth = PlayerData.player_health
	$HealthBar.value = currHealth
	riffs = [$Riff1, $Riff2]
	projectiles = [
		book_scn,
		stapler_scn,
		pencils_scn,
		trophy_scn,
		ruler_scn,
		triangle_ruler_scn,
		scissors_scn,
		calculator_scn,
		tape_scn,
		eraser_scn,
		sharpener_scn,
		glue_scn]
	projectile_spawns = [
		$ProjectileSpawnTop,
		$ProjectileSpawnBot,
		$ProjectileSpawnBotLeft,
		$ProjectileSpawnBotRight,
		$ProjectileSpawnLeft,
		$ProjectileSpawnRight,
		$ProjectileSpawnTopRight,
		$ProjectileSpawnTopLeft]
	DialogueLabel.seconds_per_step = 1.0
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	hud = get_tree().current_scene.get_node("HUD")
	level = get_tree().current_scene
	curr_objective = level.objectives[-1]
	$RiffInner/CollisionShape2D.shape.radius = PlayerData.damage_radius
	$RiffOuter/CollisionShape2D.shape.radius = PlayerData.knockback_radius
	if PlayerData.dexter_party:
		$LightningTimer.start()
	if PlayerData.jerry_party:
		$RiffTimer.start()

func _physics_process(delta):
	if not talking:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			autothrow()
		if currStamina <= 0:
			currSpeedMultipler = 1
		regen_stamina()
		velocity.x = handle_movement(Input.get_axis("left", "right"), velocity.x)
		velocity.y = handle_movement(Input.get_axis("up", "down"), velocity.y)
		if PlayerData.has_fire_extinguisher:
			if not $FireExtinguisherAttack/ActiveTimer.is_stopped():
				var active = $FireExtinguisherAttack/ActiveTimer
				hud.update_fire_extinguisher_cooldown_bar(100 - ((active.wait_time - active.time_left) / active.wait_time) * 100)
			else:
				var cooldown = $FireExtinguisherAttack/CooldownTimer
				hud.update_fire_extinguisher_cooldown_bar(((cooldown.wait_time - cooldown.time_left) / cooldown.wait_time) * 100)
		should_flip_sprite(Input.get_axis("left", "right"))
		play_walk_anim()
		rotate_spawns()
		push_object(move_and_collide(velocity * delta))

func _input(event):
	if not talking:
		if event.is_action_pressed("fire_extinguisher") and can_use_fire_extinguisher():
			use_extinguisher()
		if event.is_action_pressed("use") and holding == "":
			use()
		if event.is_action_pressed("sprint") and currStamina > 0:
			currSpeedMultipler = sprintSpeedMultiplier
		if event.is_action_released("sprint"):
			currSpeedMultipler = 1

func use_extinguisher():
	$FireExtinguisherAttack.visible = true
	$FireExtinguisherAttack/CollisionPolygon2D.disabled = false
	$FireExtinguisherAttack/DamageTimer.start()
	$FireExtinguisherAttack/ActiveTimer.start()

func use():
	var actionables = $ActionableFinder.get_overlapping_areas()
	if actionables.size() > 0:
		var actionable_type = actionables[0].action()
		if actionable_type[0] == Enums.ActionableType.DIALOGUE:
			talking = true
			level.freeze_zombies = true
		elif actionable_type[0] == Enums.ActionableType.INTERACTABLE:
			$HoldingSprite.visible = true
			$HoldingSprite.texture = table_sprite
			$PlayerAnimation.play("holding_walking")
			$PlayerAnimation.stop()
			holding = actionable_type[1]

func take_damage(damage: int):
	if not invincible:
		currHealth -= damage
		$HealthBar.value = currHealth
		if currHealth <= 0:
			hud.dead()
		else:
			PlayerData.player_health = currHealth
			player_camera.shake()
			hud.hit()
			invincible = true
			$HurtSound.play()
			$AnimationPlayer.play("take_damage")
			$InvincibilityTimer.start()

func can_use_fire_extinguisher():
	return $FireExtinguisherAttack/CooldownTimer.is_stopped() and $FireExtinguisherAttack/ActiveTimer.is_stopped() and PlayerData.has_fire_extinguisher

func update_health_bar():
	$HealthBar.value = currHealth

func push_object(collision):
	if collision and collision.get_collider().is_in_group("MoveableEnvironment"):
		var collider = collision.get_collider()
		collision.get_collider().apply_impulse(-collision.get_normal() * collider.inertia)

func instance_random_projectile():
	return RngUtils.array(projectiles)[0].instantiate()

func regen_stamina():
	if currStamina < 100:
		currStamina += 1
		$StaminaBar.value = currStamina

func autothrow():
	if can_autothrow:
		throw()
		$AutoThrowCooldown.start()
		can_autothrow = false

func throw():
	var projectile_to_throw
	var projectile_spawn_point
	if holding != "":
		projectile_to_throw = table_scn.instantiate()
		projectile_spawn_point = get_closest_projectile_spawn()
		projectile_to_throw.position = projectile_spawn_point.get_global_position()
		projectile_to_throw.rotation_degrees = projectile_spawn_point.rotation_degrees
		projectile_to_throw.apply_impulse(Vector2(500, 0).rotated(projectile_spawn_point.global_rotation))
		get_tree().current_scene.call_deferred("add_child", projectile_to_throw)
		$HoldingSprite.visible = false
		$PlayerAnimation.play("walking")
		$PlayerAnimation.stop()
		holding = ""
		$ThrowSoundEffect.play()
	elif PlayerData.projectiles_left > 0:
		PlayerData.projectiles_left -= 1
		projectile_to_throw = instance_random_projectile()
		projectile_spawn_point = get_closest_projectile_spawn()
		projectile_to_throw.position = projectile_spawn_point.get_global_position()
		projectile_to_throw.rotation_degrees = projectile_spawn_point.rotation_degrees
		projectile_to_throw.rotation = RngUtils.float_range(-180, 180)
		projectile_to_throw.apply_impulse(Vector2(500, 0).rotated(projectile_spawn_point.global_rotation))
		get_tree().get_root().call_deferred("add_child", projectile_to_throw)
		$ThrowSoundEffect.play()

func _on_dialogue_ended(resource: DialogueResource):
	talking = false
	level.freeze_zombies = false
	var title = resource.get_titles()[0]
	if title == "dexter_intro":
		$LightningTimer.start()
		level.complete_objective()
		PlayerData.dexter_party = true
		get_tree().current_scene.get_node("Dexter").queue_free()
	elif title == "jerry_intro":
		$RiffTimer.start()
		level.complete_objective()
		level.get_node("HoldoutTrigger").is_active = true
		PlayerData.jerry_party = true
		get_tree().current_scene.get_node("Jerry").queue_free()

func rotate_spawns():
	for spawn in projectile_spawns:
		spawn.look_at(get_global_mouse_position())

func get_closest_projectile_spawn():
	var closest = projectile_spawns[0]
	var closest_dist = projectile_spawns[0].global_position.distance_to(get_global_mouse_position())
	for spawn in projectile_spawns:
		var dist = spawn.global_position.distance_to(get_global_mouse_position())
		if dist < closest_dist:
			closest = spawn
			closest_dist = dist
	return closest

func play_walk_anim():
	if abs(velocity.x) > 0 or abs(velocity.y) > 0:
		if currSpeedMultipler > 1:
			$PlayerAnimation.play("sprinting" if holding == "" else "holding_sprinting")
		else:
			$PlayerAnimation.play("walking" if holding == "" else "holding_walking")
	else:
		$PlayerAnimation.stop()

func handle_movement(direction, curr_velocity):
	var new_velocity
	if direction:
		if currSpeedMultipler > 1:
			currStamina -= 2
			$StaminaBar.value = currStamina
		new_velocity = direction * (SPEED / (1 if holding == "" else 2)) * currSpeedMultipler
	else:
		new_velocity = move_toward(curr_velocity, 0, SPEED)
	return new_velocity

func should_flip_sprite(direction):
	if direction > 0 and $PlayerAnimation.flip_h:
		$PlayerAnimation.flip_h = false
	elif direction < 0 and not $PlayerAnimation.flip_h:
		$PlayerAnimation.flip_h = true

func get_collision_position():
	return $CollisionShape2D.global_position

func _on_lightning_timer_timeout():
	if not talking:
		var zombies: Array[Node2D] = $LightningArea.get_overlapping_bodies()
		if len(zombies) > 0:
			for i in range(PlayerData.num_shock):
				if len(zombies) <= 0:
					break
				var random_zombie_index = RngUtils.int_range(0, len(zombies) - 1)
				var closest_zombie = zombies[random_zombie_index]
				zombies.pop_at(random_zombie_index)
				var lightning: Line2D = lightning_scn.instantiate()
				lightning.add_point(global_position)
				lightning.add_point(closest_zombie.global_position)
				get_tree().get_root().call_deferred("add_child", lightning)
				$LightningSound.play()
				closest_zombie.take_damage()

func _on_invincibility_timer_timeout():
	$AnimationPlayer.stop()
	invincible = false

func _on_riff_timer_timeout():
	if not talking:
		RngUtils.array(riffs)[0].play()
		var rumble_particle_instance = rumble_scn.instantiate()
		rumble_particle_instance.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", rumble_particle_instance)
		rumble_particle_instance.emitting = true
		rumble_particle_instance.start_emit = true
		var zombies_inner: Array[Node2D] = $RiffInner.get_overlapping_bodies()
		var zombies_outer: Array[Node2D] = $RiffOuter.get_overlapping_bodies()
		for inner_zombie in zombies_inner:
			inner_zombie.take_damage()
		for i in range(len(zombies_outer) - 1, -1, -1):
			zombies_outer[i].knockback()

func _on_enemy_projectile_detector_body_entered(body):
	body.queue_free()
	take_damage(5)

func _on_auto_throw_cooldown_timeout():
	can_autothrow = true
