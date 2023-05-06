extends CharacterBody2D


@export var SPEED = 50
@export var health = 10

var player
var blood = preload("res://instances/blood_splatter.tscn")
var damaged_by = []
var hit_sounds
var dead = false

var rng = RandomNumberGenerator.new()

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	player = get_tree().current_scene.get_node("Player")
	hit_sounds = [$HitSound1, $HitSound2, $HitSound3]

func _physics_process(delta):
	if position.distance_to(player.position) < 200:
		var velocity = position.direction_to(player.position)
		should_flip_sprite(velocity.x)
		push_object(move_and_collide(velocity * SPEED * delta))

func push_object(collision):
	if collision and collision.get_collider().is_in_group("MoveableEnvironment"):
		var collider = collision.get_collider()
		collision.get_collider().apply_central_impulse(-collision.get_normal() * collider.inertia)

func should_flip_sprite(direction):
	if direction > 0 and $Sprite2D.flip_h:
		$Sprite2D.flip_h = false
	elif direction < 0 and not $Sprite2D.flip_h:
		$Sprite2D.flip_h = true

func _on_projectile_detector_body_entered(body):
	var body_velocity = body.linear_velocity
	if (abs(body.linear_velocity.x) > 30 or abs(body.linear_velocity.y) > 30) and body not in damaged_by:
		health -= 1
		var hit_sound = hit_sounds[rng.randi_range(0, len(hit_sounds) - 1)]
		hit_sound.play()
		var blood_instance = blood.instantiate()
		get_tree().current_scene.add_child(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = global_position.angle_to_point(player.global_position) + 180
		if health <= 0:
			dead = true
			$CollisionShape2D.set_deferred("disabled", true)
			$ProjectileDetector/CollisionShape2D.set_deferred("disabled", true)
			$PlayerDetector/CollisionShape2D.set_deferred("disabled", true)
			visible = false
		$HealthBar.value = health
		damaged_by.append(body)

func _on_hit_sound_finished():
	if dead:
		queue_free()
