extends Spatial

var camrot_h = 0
var camrot_v = 0
var cam_v_min = -55
var cam_v_max = 75
var h_sensitivity = 0.1
var v_sensitivity = 0.1
var h_acceleration = 10
var v_acceleration = 10
var mode = false


func _ready():
	if Input.is_action_just_pressed("Esc"):
			$Status/Back.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISBLE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/pivot/ClippedCamera.add_exception(get_parent())
	
func _input(event):
	if is_network_master():
		if Camu.camlock == false:
			if event is InputEventMouseMotion:
				camrot_h += -event.relative.x * h_sensitivity
				camrot_v += event.relative.y  * v_sensitivity
	

func _physics_process(delta):
	
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * h_acceleration)
