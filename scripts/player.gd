extends CharacterBody2D

@onready var book_scn = preload("res://instances/book.tscn")
@onready var stapler_scn = preload("res://instances/stapler.tscn")

@export var SPEED = 300.0

var projectiles = ["book", "stapler"]
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	velocity.x = handle_movement(Input.get_axis("left", "right"), velocity.x)
	velocity.y = handle_movement(Input.get_axis("up", "down"), velocity.y)

	move_and_collide(velocity * delta)
	$ProjectileSpawn.look_at(get_global_mouse_position())

func _input(event):
	if event.is_action_pressed("throw"):
		throw()

func instance_random_projectile():
	var random_projectile = rng.randi_range(0, len(projectiles) - 1)
	match(projectiles[random_projectile]):
		"book":
			return book_scn.instantiate()
		"stapler":
			return stapler_scn.instantiate()

func throw():
	var projectile_to_throw = instance_random_projectile()
	get_tree().get_root().call_deferred("add_child", projectile_to_throw)
	projectile_to_throw.position = $ProjectileSpawn/Marker2D.get_global_position()
	projectile_to_throw.velocity = get_global_mouse_position() - projectile_to_throw.position
	

func handle_movement(direction, curr_velocity):
	var new_velocity
	if direction:
		new_velocity = direction * SPEED
	else:
		new_velocity = move_toward(curr_velocity, 0, SPEED)
	return new_velocity
