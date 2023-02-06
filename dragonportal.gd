extends StaticBody

var can_travel = false

func _process(delta):
	if can_travel == true:
		$Label.visible = true
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene("res://Spatial.tscn")
	else:
		$Label.visible = false

func _on_pls_work_thistime_body_entered(body):
	if body.name == "Player":
		can_travel = true


func _on_pls_work_thistime_body_exited(body):
	if body.name == "Player":
		can_travel = false
