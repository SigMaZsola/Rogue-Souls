extends SpringArm

var camlock = false

func _ready():
	$ClippedCamera.add_exception(get_parent())
	
func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion && camlock == false:
			rotation_degrees.x = clamp(rotation_degrees.x-event.relative.y*0.1,-45,45)
			rotation_degrees.y = clamp(rotation_degrees.y-event.relative.x*0.1,-45,45)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("brake"):
		if camlock == false:
			camlock = true
		else:
			camlock = false
			
	if camlock == true:
		rotation.x = lerp_angle(rotation.x,0,0.1)
		rotation.y = lerp_angle(rotation.y,0,0.1)
