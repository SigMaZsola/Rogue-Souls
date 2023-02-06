extends Spatial

func _physics_process(delta):
	$AnimationPlayer.play("IDLE")
