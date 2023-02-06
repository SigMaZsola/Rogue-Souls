extends Area


func _on_Ltra_body_exited(body):
	if body.is_in_group("Player"):
		if body.climbing == true:
			body.climbing = false
			

func _on_Ltra_body_entered(body):
	if body.is_in_group("Player"):
		if body.climbing == false:
			body.climbing = true
			
