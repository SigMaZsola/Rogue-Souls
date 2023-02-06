extends RigidBody

var damage = false
var hp = 100

func _process(delta):
	
	if hp == 0:
		mode = MODE_RIGID
	
	if damage == true:
		$MeshInstance.get_surface_material(0).set_albedo(Color(1,0,0))
	else:
		$MeshInstance.get_surface_material(0).set_albedo(Color(0,1,0))
