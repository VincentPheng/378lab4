extends CanvasLayer

@export var stats: Resource

func _ready():
	$CRTFilter.visible = true
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -25)

func _input(event):
	if event is InputEventMouseMotion:
		$Crosshair.position = event.position
	if event.is_action_pressed("pause"):
		$PauseScreen.visible = not $PauseScreen.visible
		get_tree().paused = not get_tree().paused 

func _process(delta):
	$BoxCount.text = "%03d" % stats.projectiles_left


func _on_audio_slider_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), $PauseScreen/AudioSlider.value)


func _on_crt_filter_option_pressed():
	$CRTFilter.visible = not $CRTFilter.visible
