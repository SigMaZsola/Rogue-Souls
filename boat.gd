extends RigidBody


func _physics_process(delta):
	if $Spatial.global_transform.origin.y <= 0:
		add_force(Vector3.UP*20 *-$Spatial.global_transform.origin, $Spatial.global_transform.origin-global_transform.origin)
	if $Spatial2.global_transform.origin.y <= 0:
		add_force(Vector3.UP*20 *-$Spatial2.global_transform.origin, $Spatial2.global_transform.origin-global_transform.origin)
	if $Spatial3.global_transform.origin.y <= 0:
		add_force(Vector3.UP*20 *-$Spatial3.global_transform.origin, $Spatial3.global_transform.origin-global_transform.origin)
	if $Spatial4.global_transform.origin.y <= 0:
		add_force(Vector3.UP*20 *-$Spatial4.global_transform.origin, $Spatial4.global_transform.origin-global_transform.origin)
