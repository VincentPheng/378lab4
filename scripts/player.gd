extends CharacterBody2D

@onready var book_scn = preload("res://instances/book.tscn")
@onready var stapler_scn = preload("res://instances/stapler.tscn")
@onready var table_scn = preload("res://instances/table.tscn")
@onready var table_sprite = preload("res://sprites/table.png")

@export var SPEED = 300.0
@export var stats: Resource

var projectiles = ["book", "stapler"]
var rng = RandomNumberGenerator.new()
var projectile_spawns
var holding := ""

var talking = false

func _ready():
	projectile_spawns = [
		$ProjectileSpawnTop,
		$ProjectileSpawnBot,
		$ProjectileSpawnBotLeft,
		$ProjectileSpawnBotRight,
		$ProjectileSpawnLeft,
		$ProjectileSpawnRight,
		$ProjectileSpawnTopRight,
		$ProjectileSpawnTopLeft]
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	

func _physics_process(delta):
	if not talking:
		velocity.x = handle_movement(Input.get_axis("left", "right"), velocity.x)
		velocity.y = handle_movement(Input.get_axis("up", "down"), velocity.y)
		should_flip_sprite(Input.get_axis("left", "right"))
		play_walk_anim()
		rotate_spawns()
		push_object(move_and_collide(velocity * delta))
		

func _input(event):
	if not talking:
		if event.is_action_pressed("throw"):
			throw()
		if event.is_action_pressed("use") and holding == "":
			var actionables = $ActionableFinder.get_overlapping_areas()
			if actionables.size() > 0:
				var actionable_type = actionables[0].action()
				if actionable_type[0] == Enums.ActionableType.DIALOGUE:
					talking = true
				elif actionable_type[0] == Enums.ActionableType.INTERACTABLE:
					$HoldingSprite.visible = true
					$HoldingSprite.texture = table_sprite
					$PlayerAnimation.play("holding_walking")
					$PlayerAnimation.stop()
					holding = actionable_type[1]

func push_object(collision):
	if collision and collision.get_collider().is_in_group("MoveableEnvironment"):
		var collider = collision.get_collider()
		collision.get_collider().apply_impulse(-collision.get_normal() * collider.inertia)

func instance_random_projectile():
	var random_projectile = rng.randi_range(0, len(projectiles) - 1)
	match(projectiles[random_projectile]):
		"book":
			return book_scn.instantiate()
		"stapler":
			return stapler_scn.instantiate()

func throw():
	var projectile_to_throw
	var projectile_spawn_point
	if holding != "":
		projectile_to_throw = table_scn.instantiate()
		projectile_spawn_point = get_closest_projectile_spawn()
		projectile_to_throw.position = projectile_spawn_point.get_global_position()
		projectile_to_throw.rotation_degrees = projectile_spawn_point.rotation_degrees
		projectile_to_throw.apply_impulse(Vector2(500, 0).rotated(projectile_spawn_point.global_rotation))
		get_tree().get_root().call_deferred("add_child", projectile_to_throw)
		$HoldingSprite.visible = false
		$PlayerAnimation.play("walking")
		$PlayerAnimation.stop()
		holding = ""
		$ThrowSoundEffect.play()
	elif stats.projectiles_left > 0:
		stats.projectiles_left -= 1
		projectile_to_throw = instance_random_projectile()
		projectile_spawn_point = get_closest_projectile_spawn()
		projectile_to_throw.position = projectile_spawn_point.get_global_position()
		projectile_to_throw.rotation_degrees = projectile_spawn_point.rotation_degrees
		projectile_to_throw.rotation = rng.randf_range(-180, 180)
		projectile_to_throw.apply_impulse(Vector2(500, 0).rotated(projectile_spawn_point.global_rotation))
		get_tree().get_root().call_deferred("add_child", projectile_to_throw)
		$ThrowSoundEffect.play()

func _on_dialogue_ended(resource: DialogueResource):
	talking = false

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
		$PlayerAnimation.play("walking" if holding == "" else "holding_walking")
	else:
		$PlayerAnimation.stop()

func handle_movement(direction, curr_velocity):
	var new_velocity
	if direction:
		new_velocity = direction * (SPEED / (1 if holding == "" else 2))
	else:
		new_velocity = move_toward(curr_velocity, 0, SPEED)
	return new_velocity

func should_flip_sprite(direction):
	if direction > 0 and $PlayerAnimation.flip_h:
		$PlayerAnimation.flip_h = false
	elif direction < 0 and not $PlayerAnimation.flip_h:
		$PlayerAnimation.flip_h = true
