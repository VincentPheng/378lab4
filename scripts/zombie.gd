extends CharacterBody2D
class_name Zombie

@export var SPEED = 50
@export var health = 10
@export var permanent = false
@export var loot_drop_chance = 10
@export var damage = 10
@export var knockback_multiplier = 5

var player
var level
var blood = preload("res://instances/blood_splatter.tscn")
var projectile_box = preload("res://instances/projectile_box.tscn")
var health_pack = preload("res://instances/health_pack.tscn")
var damaged_by = []
var hit_sounds
var moan_sounds
var dead = false
var in_player_range := false
var despawn_range := false
var loot: Array[Resource]

var last_delta
var rng = RandomNumberGenerator.new()

func _ready():
	loot = [projectile_box, health_pack]
	$HealthBar.max_value = health
	$HealthBar.value = health
	level = get_tree().current_scene
	player = get_tree().current_scene.get_node("Player")
	hit_sounds = [$HitSound1, $HitSound2, $HitSound3]
	moan_sounds = [$MoanSound1, $MoanSound2]

func _physics_process(delta):
	last_delta = delta
	if not permanent:
		despawn_range = position.distance_to(player.position) > 400
		if despawn_range:
			queue_free()
	in_player_range = position.distance_to(player.position) < 200
	if in_player_range and not level.freeze_zombies:
		var velocity = position.direction_to(player.position)
		should_flip_sprite(velocity.x)
		push_object(move_and_collide(velocity * SPEED * delta))

func knockback():
	collision_mask = 66
	var velocity = position.direction_to(player.position) * -1
	push_object(move_and_collide(velocity * SPEED * knockback_multiplier * last_delta))
	collision_mask = 70

func push_object(collision):
	if collision and collision.get_collider().is_in_group("MoveableEnvironment"):
		var collider = collision.get_collider()
		collision.get_collider().apply_central_impulse(-collision.get_normal() * collider.inertia)

func should_flip_sprite(direction):
	if direction > 0 and $Sprite2D.flip_h:
		$Sprite2D.flip_h = false
	elif direction < 0 and not $Sprite2D.flip_h:
		$Sprite2D.flip_h = true

func take_damage():
	health -= 1
	var hit_sound = hit_sounds[rng.randi_range(0, len(hit_sounds) - 1)]
	hit_sound.play()
	var blood_instance = blood.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	blood_instance.rotation = global_position.angle_to_point(player.global_position) + 180
	if health <= 0:
		dead = true
		PlayerData.zombies_killed += 1
		should_drop_loot()
		$CollisionShape2D.set_deferred("disabled", true)
		$ProjectileDetector/CollisionShape2D.set_deferred("disabled", true)
		$PlayerDetector/CollisionShape2D.set_deferred("disabled", true)
		visible = false
	$HealthBar.value = health

func should_drop_loot():
	var roll = rng.randi_range(1, 100)
	if roll <= loot_drop_chance:
		var loot_instance = loot[rng.randi_range(0, len(loot) - 1)].instantiate()
		get_tree().current_scene.call_deferred("add_child", loot_instance)
		loot_instance.global_position = global_position

func _on_projectile_detector_body_entered(body):
	if (abs(body.linear_velocity.x) > 30 or abs(body.linear_velocity.y) > 30) and body not in damaged_by:
		take_damage()
		damaged_by.append(body)

func _on_hit_sound_finished():
	if dead:
		queue_free()


func _on_moan_timer_timeout():
	if in_player_range:
		var sound = moan_sounds[rng.randi_range(0, len(moan_sounds) - 1)]
		sound.play()
		$MoanTimer.start()


func _on_player_detector_body_entered(body: Player):
	if not body.invincible:
		body.take_damage(damage)
		$AttackSound.play()
