extends KinematicBody

var direction = Vector3(0,0,1)

func _process(delta):
		direction = -global_transform.basis.z
		direction = move_and_slide(direction * 6)
		


func _on_Timer_timeout():
	queue_free()


func _on_Area_body_entered(body):
	if body.name == "Player":
		body.h.value -= 30
		body.hurt()
	else:
		pass


func _on_Area_body_exited(body):
	pass # Replace with function body.
