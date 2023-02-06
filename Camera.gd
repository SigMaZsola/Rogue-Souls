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
var cam_lock = false
onready var fov = $h/v/pivot/ClippedCamera.fov

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/pivot/ClippedCamera.add_exception(get_parent())
	
	
	
func _input(event):
	
	if Camu.camlock == false:
		if event is InputEventMouseMotion:
			camrot_h += -event.relative.x * h_sensitivity
			camrot_v += event.relative.y  * v_sensitivity
	else:
		pass
func _physics_process(delta):
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	fov = GlobalSettings.fov
	v_sensitivity = GlobalSettings.mouse_sens
	h_sensitivity = GlobalSettings.mouse_sens
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * h_acceleration)


func _on_Aim_decetion_body_entered(body):
	pass # Replace with function body.
