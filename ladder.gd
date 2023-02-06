extends StaticBody



func _on_Area_body_entered(body):
	if body.name == "Player":
		body.climbing = true


func _on_Area_body_exited(body):
	if body.name == "Player":
		body.climbing = false
