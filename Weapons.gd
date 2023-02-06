extends Spatial



func _on_Area_body_entered(body):
	if body.is_in_group("spider"):
		if Globals.can_slash == true:
			
			body.hp -= 80
			body.particel.emitting = true
	


func _on_Area_body_exited(body):
	if body.is_in_group("spider"):
		pass
