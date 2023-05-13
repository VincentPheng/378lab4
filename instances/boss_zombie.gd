extends CharacterBody2D
class_name BossZombie

@export var SPEED = 50
@export var health = 10
@export var damage = 10

var player
var level
var healthbar
var blood = preload("res://instances/blood_splatter.tscn")
var grub = preload("res://instances/grub.tscn")
var damaged_by = []
var hit_sounds
var moan_sounds
var dead = false
var invincible := false
var rng = RandomNumberGenerator.new()
var switching_phase := false
var grub_throw := true
var curr_phase = 0

signal phase_change(curr_phase)
signal death

func _ready():
	level = get_tree().current_scene
	player = get_tree().current_scene.get_node("Player")
	healthbar = get_tree().current_scene.get_node("HUD/HealthBar")
	hit_sounds = [$HitSound1, $HitSound2, $HitSound3]
	moan_sounds = [$MoanSound1, $MoanSound2]
	healthbar.max_value = health
	healthbar.value = health

func _physics_process(delta):
	if not switching_phase:
		if not level.freeze_zombies:
			var p_velocity = position.direction_to(player.position)
			should_flip_sprite(p_velocity.x)
			push_object(move_and_collide(p_velocity * SPEED * delta))

func knockback():
	collision_mask = 66
	var p_velocity = position.direction_to(player.position) * -1
	push_object(move_and_collide(Vector2(0, 0)))
	collision_mask = 70

func push_object(collision):
	if collision and collision.get_collider().is_in_group("MoveableEnvironment"):
		var collider = collision.get_collider()
		collision.get_collider().apply_central_impulse(-collision.get_normal() * collider.inertia * 100)

func should_flip_sprite(direction):
	if direction > 0 and $Sprite2D.flip_h:
		$CollisionShape2D.position.x *= -1
		$PlayerDetector/CollisionShape2D.position.x *= -1
		$ProjectileBounceDetector/CollisionShape2D.position.x *= -1
		$ProjectileDetector/CollisionShape2D.position.x *= -1
		$Sprite2D.flip_h = false
	elif direction < 0 and not $Sprite2D.flip_h:
		$CollisionShape2D.position.x *= -1
		$PlayerDetector/CollisionShape2D.position.x *= -1
		$ProjectileBounceDetector/CollisionShape2D.position.x *= -1
		$ProjectileDetector/CollisionShape2D.position.x *= -1
		$Sprite2D.flip_h = true

func phase_switch():
	SPEED = 90
	switching_phase = true
	curr_phase += 1
	phase_change.emit(curr_phase)
	if curr_phase == 2:
		$GrubAttackSpeedTimer.wait_time = 0.1
		$GrubCooldownTimer.start()
	invincible = true
	healthbar.visible = false
	$AnimationPlayer.play("phase_switch")
	$InvincibilityTimer.start()

func take_damage():
	if not invincible:
		health -= 1
		var hit_sound = hit_sounds[rng.randi_range(0, len(hit_sounds) - 1)]
		hit_sound.play()
		var blood_instance = blood.instantiate()
		get_tree().current_scene.add_child(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = global_position.angle_to_point(player.global_position) + 180
		if health == 200 or health == 100:
			phase_switch()
		if health <= 0:
			$CollisionShape2D.set_deferred("disabled", true)
			$ProjectileDetector/CollisionShape2D.set_deferred("disabled", true)
			$PlayerDetector/CollisionShape2D.set_deferred("disabled", true)
			$ProjectileBounceDetector/CollisionShape2D.set_deferred("disabled", true)
			visible = false
			dead = true
			PlayerData.zombies_killed += 1
			death.emit()
		healthbar.value = health

func _on_projectile_detector_body_entered(body):
	if body not in damaged_by:
		if body.is_in_group("MoveableEnvironment"):
			if (abs(body.linear_velocity.x) > 50 or abs(body.linear_velocity.y) > 50):
				take_damage()
		elif body.is_in_group("EnemyProjectile"):
			take_damage()
		else:
			take_damage()
			body.fade()
		damaged_by.append(body)

func _on_hit_sound_finished():
	if dead:
		queue_free()


func _on_moan_timer_timeout():
	var sound = moan_sounds[rng.randi_range(0, len(moan_sounds) - 1)]
	sound.play()
	$MoanTimer.start()


func _on_player_detector_body_entered(body: Player):
	if not body.invincible:
		body.take_damage(damage)
		$AttackSound.play()


func _on_invincibility_timer_timeout():
	SPEED = 50
	invincible = false
	healthbar.visible = true
	$Sprite2D.modulate = Color(1, 1, 1, 1)
	if curr_phase == 1:
		$GrubAttackSpeedTimer.start()


func _on_animation_player_animation_finished(_anim_name):
	switching_phase = false
	$Sprite2D.modulate = Color(255, 0, 0, 255)
	$InvincibilityTimer.start()


func _on_grub_attack_speed_timer_timeout():
	if grub_throw:
		var grub_instance: RigidBody2D = grub.instantiate()
		grub_instance.global_position = global_position
		grub_instance.apply_impulse(200 * global_position.direction_to(player.global_position))
		get_tree().current_scene.call_deferred("add_child", grub_instance)


func _on_grub_cooldown_timer_timeout():
	grub_throw = not grub_throw
