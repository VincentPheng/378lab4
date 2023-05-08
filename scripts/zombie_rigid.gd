extends RigidBody2D

@export var speed = 50

var player

func _ready():
	player = get_tree().current_scene.get_node("Player")

func _process(delta):
	var direction = position.direction_to(player.position)
	apply_force(direction * speed)
