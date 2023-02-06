extends Spatial




func _on_Area_body_entered(body):
	Camu.last_position = $Position3D.global_transform.origin
