extends StaticBody

var can_hurt = false

var wait_time = 0

	
		

func _on_Area_body_entered(body):
	if body.name == "Player":
		$Particles.emitting = true
		$Timer.start()
		can_hurt = true
		


func _on_Timer_timeout():
		if can_hurt == true:
			Globals.ph -= 100
		queue_free()
		
		


func _on_Area_body_exited(body):
	if body.name == "Player":
		can_hurt = false
