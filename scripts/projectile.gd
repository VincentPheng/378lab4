extends CharacterBody2D
class_name Projectile

@export var SPEED = 500

func _physics_process(delta):
	move_and_collide(velocity.normalized() * delta * SPEED)

