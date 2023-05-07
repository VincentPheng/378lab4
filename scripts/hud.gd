extends CanvasLayer

var filter_material: ShaderMaterial

func _ready():
	$CRTFilter.visible = true
	$PauseScreen.visible = false
	
	filter_material = $CRTFilter/ColorRect.material
	var scanline_count = filter_material.get_shader_parameter("scanline_count")
	$PauseScreen/ScanlineLabel/ScanlineSlider.value = scanline_count
	var warp = 10 - filter_material.get_shader_parameter("warp")
	$PauseScreen/CRTWarpLabel/CRTWarpSlider.value = warp
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -15)

func _input(event):
	if event is InputEventMouseMotion:
		$Crosshair.position = event.position
	if event.is_action_pressed("pause"):
		$PauseScreen.visible = not $PauseScreen.visible
		get_tree().paused = not get_tree().paused 

func _process(delta):
	$BoxCount.text = "%03d" % PlayerData.projectiles_left


func _on_audio_slider_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), $PauseScreen/AudioSlider.value)


func _on_crt_filter_option_pressed():
	$CRTFilter.visible = not $CRTFilter.visible


func _on_scanline_slider_drag_ended(value_changed):
	filter_material.set_shader_parameter("scanline_count", $PauseScreen/ScanlineLabel/ScanlineSlider.value)


func _on_crt_warp_slider_drag_ended(value_changed):
	filter_material.set_shader_parameter("warp", 10 - $PauseScreen/CRTWarpLabel/CRTWarpSlider.value)
