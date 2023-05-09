extends CanvasLayer

var next_scene: String
var progress = []
var scene_load_status = 0

func _ready():
	ResourceLoader.load_threaded_request(next_scene)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene,progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene))
		queue_free()
