extends Control



func _physics_process(delta):
	$ColorRect2/Label.text = str(Engine.get_frames_per_second())  + " FPS"
	

