extends Spatial

func _process(delta):
	rotation_degrees.y = lerp_angle(rotation_degrees.y, rotation_degrees.y+180, 0.5)

func _on_Area_body_entered(body):
	if body.name == "Player":
		body.flasks += 1
		queue_free()
