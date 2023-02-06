extends StaticBody



func _on_Area_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("fel")
		yield(get_tree().create_timer(0.5), "timeout")
		body.h.value = 0
	if body.is_in_group("spider"):
		$AnimationPlayer.play("fel")
		yield(get_tree().create_timer(0.5), "timeout")
		body.hp = 0



func _on_Area_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("le")
