extends CPUParticles2D

var start_emit = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not emitting and start_emit:
		queue_free()
