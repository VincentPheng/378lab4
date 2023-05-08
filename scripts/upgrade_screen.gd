extends CanvasLayer

@export var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$DexterUpgrade/ShockCooldown.text = "%.1fs" % PlayerData.shock_cooldown
	$DexterUpgrade/ShockNumber.text = "%d" % PlayerData.num_shock
	
	$JerryUpgrade.visible = PlayerData.jerry_party
	$CoilCountLabel.text = "%02d" % PlayerData.num_coils
	$SubwooferCountLabel.text = "%02d" % PlayerData.num_subwoofer

func _on_next_button_pressed():
	get_tree().change_scene_to_file(next_scene)


func _on_upgrade_shock_number_button_pressed():
	if PlayerData.num_coils >= 1:
		PlayerData.num_coils -= 1
		PlayerData.num_shock += 1
		$DexterUpgrade/ShockNumber.text = "%d" % PlayerData.num_shock
		$CoilCountLabel.text = "%02d" % PlayerData.num_coils


func _on_upgrade_shock_cooldown_button_pressed():
	if PlayerData.num_coils >= 1:
		PlayerData.num_coils -= 1
		PlayerData.shock_cooldown -= 0.5
		$DexterUpgrade/ShockCooldown.text = "%.1fs" % PlayerData.shock_cooldown
		$CoilCountLabel.text = "%02d" % PlayerData.num_coils
