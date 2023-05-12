extends CanvasLayer

var loading_screen = preload("res://scenes/load.tscn")

func _ready():
	$GodotScreen.visible = true

func _on_start_button_pressed():
	var loading_screen_instance = loading_screen.instantiate()
	loading_screen_instance.next_scene = "res://scenes/test_level.tscn"
	add_child(loading_screen_instance)


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credit_screen.tscn")


func _on_animation_player_animation_finished(anim_name):
	$GodotScreen.queue_free()
