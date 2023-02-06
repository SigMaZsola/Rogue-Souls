extends Spatial

	
var can_travel = false

func _process(delta):
	if can_travel == true:
		if Input.is_action_just_pressed("interact"):
			owner.dungeon = true
	else:
		pass

func _on_Area_body_entered(body):
	if body.name == "Player":
		$Area/Label.visible = true
		can_travel = true
			


func _on_Area_body_exited(body):
	if body.name == "Player":
		$Area/Label.visible = false
		can_travel = false
