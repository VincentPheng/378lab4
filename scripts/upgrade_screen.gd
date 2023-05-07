extends CanvasLayer

@export var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$JerryUpgrade.visible = PlayerData.jerry_party
	$CoilCountLabel.text = "%02d" % PlayerData.num_coils
	$SubwooferCountLabel.text = "%02d" % PlayerData.num_subwoofer

func _on_next_button_pressed():
	get_tree().change_scene_to_file(next_scene)


func _on_button_2_pressed():
	print('HELLO')
