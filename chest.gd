extends StaticBody




func _on_Area_body_entered(body):
	if body.name == "Player":
		$AnimationTree.set("parameters/jap/current", 0)
		


func _on_Area_body_exited(body):
	if body.name == "Player":
		$AnimationTree.set("parameters/jap/current", 1)
