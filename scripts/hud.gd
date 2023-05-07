extends CanvasLayer
class_name HUD

var filter_material: ShaderMaterial
var next_scene: String

func _ready():
	$CRTFilter.visible = PlayerData.crt_enabled
	$PauseScreen.visible = false
	$DeathScreen.visible = false
	$EndScreen.visible = false
	
	filter_material = $CRTFilter/ColorRect.material
	
	filter_material.set_shader_parameter("scanline_count", PlayerData.crt_scanline_setting)
	var scanline_count = filter_material.get_shader_parameter("scanline_count")
	$PauseScreen/ScanlineLabel/ScanlineSlider.value = scanline_count
	
	filter_material.set_shader_parameter("warp", PlayerData.crt_warp_setting)
	var warp = 10 - filter_material.get_shader_parameter("warp")
	$PauseScreen/CRTWarpLabel/CRTWarpSlider.value = warp
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), PlayerData.audio_setting)
	$PauseScreen/AudioLabel/AudioSlider.value = PlayerData.audio_setting

func _input(event):
	if event is InputEventMouseMotion:
		$Crosshair.position = event.position
	if event.is_action_pressed("pause") and not $EndScreen.visible and not $DeathScreen.visible:
		$PauseScreen.visible = not $PauseScreen.visible
		get_tree().paused = not get_tree().paused 

func _process(delta):
	$BoxCount.text = "%03d" % PlayerData.projectiles_left

func update_objective(new_objective: String):
	$ObjectiveArea/Objective.text = new_objective

func finish(scene: String):
	next_scene = scene
	get_tree().paused = true
	$EndScreen/ZombiesKilledAmountLabel.text = "%03d" % PlayerData.zombies_killed
	$EndScreen.visible = true

func hit():
	$HitHud.visible = true
	$HitHud/HitHudFade.play("fade")

func dead():
	get_tree().paused = true
	$DeathScreen.visible = true

func _on_audio_slider_drag_ended(value_changed):
	PlayerData.audio_setting =  $PauseScreen/AudioLabel/AudioSlider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), PlayerData.audio_setting)


func _on_crt_filter_option_pressed():
	PlayerData.crt_enabled = not $CRTFilter.visible
	$CRTFilter.visible = PlayerData.crt_enabled


func _on_scanline_slider_drag_ended(value_changed):
	PlayerData.crt_scanline_setting = $PauseScreen/ScanlineLabel/ScanlineSlider.value
	filter_material.set_shader_parameter("scanline_count", PlayerData.crt_scanline_setting)


func _on_crt_warp_slider_drag_ended(value_changed):
	PlayerData.crt_warp_setting = 10 - $PauseScreen/CRTWarpLabel/CRTWarpSlider.value
	filter_material.set_shader_parameter("warp", PlayerData.crt_warp_setting)

func _on_restart_button_pressed():
	PlayerData.projectiles_left = 10
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_hit_hud_fade_animation_finished(anim_name):
	$HitHud.visible = false


func _on_upgrade_party_button_pressed():
	PlayerData.zombies_killed = 0
	get_tree().paused = false
	get_tree().change_scene_to_file(next_scene)
