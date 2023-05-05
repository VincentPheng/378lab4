extends CharacterBody2D


@export var SPEED = 50
@export var health = 10

var player
var blood = preload("res://instances/blood_splatter.tscn")

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	player = get_tree().current_scene.get_node("Player")

func _physics_process(delta):
	if position.distance_to(player.position) < 200:
		var velocity = position.direction_to(player.position)
		should_flip_sprite(velocity.x)
		move_and_collide(velocity * SPEED * delta)

func should_flip_sprite(direction):
	if direction > 0 and $Sprite2D.flip_h:
		$Sprite2D.flip_h = false
	elif direction < 0 and not $Sprite2D.flip_h:
		$Sprite2D.flip_h = true

func _on_projectile_detector_body_entered(body):
	var body_velocity = body.linear_velocity
	if not body.inactive:
		health -= 1
		var blood_instance = blood.instantiate()
		get_tree().current_scene.add_child(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = global_position.angle_to_point(player.global_position) + 180
		if health <= 0:
			queue_free()
		$HealthBar.value = health
		body.inactive = true
