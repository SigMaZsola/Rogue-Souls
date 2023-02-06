extends KinematicBody

var active = false
var direction = Vector3()
var velocity = Vector3()
var speed = 5
var gravity = 20
var jump = 10

var h_accel = 6
var h_velocity = Vector3()
var movement = Vector3()


var grav_vec = Vector3()

func _physics_process(delta):
	velocity = Vector3.ZERO
	if $RayCast2.is_colliding():
		Globals.pos1 = $Position3D2.global_transform.origin
	else: 
		Globals.pos1 = $Position3D3.global_transform.origin
	if $RayCast.is_colliding():
		Globals.pos1 = $Position3D3.global_transform.origin
	else: 
		Globals.pos1 = $Position3D2.global_transform.origin
		
	Globals.pos = $Armature/Skeleton/BoneAttachment2/Position3D.global_transform.origin
	Globals.rot = rotation.y
	velocity.z = 0
	$AnimationTree.set("parameters/Blend3/blend_amount", -1)
	if active == true:
		
		if not is_on_floor():
			grav_vec += Vector3.DOWN * gravity * delta
		else:
			grav_vec = -get_floor_normal() * gravity
			$AnimationTree.set("parameters/jump/current", 1)
		
		direction = Vector3()
		
		if Input.is_action_pressed("balra"):
			rotate_y(1 * 0.01)
		
		if Input.is_action_pressed("jobbra"):
			rotate_y(-1 * 0.01)
		
		if Input.is_action_pressed("előre"):
			direction += transform.basis.z
			speed = 5
			$AnimationTree.set("parameters/Blend3/blend_amount", 0)
			if Input.is_action_pressed("sprint"):
				speed = 20
				$AnimationTree.set("parameters/Blend3/blend_amount", 1)
				
				#Do not worry, about the horse, I could solve the problem by a simple is_on_floor(). It makes the developping process easy
				if Input.is_action_just_pressed("jump"):
					grav_vec = Vector3.UP * 10
					$AnimationTree.set("parameters/jump/current", 0)
					$AnimationTree.set("parameters/BlendSpace1D/blend_position", -grav_vec.y)
		
		direction = direction.normalized()
		h_velocity = h_velocity.linear_interpolate(direction * speed, h_accel * delta)
		
		movement.z = h_velocity.z + grav_vec.z
		movement.x = h_velocity.x + grav_vec.x
		movement.y = grav_vec.y
		
		
		move_and_slide(movement, Vector3.UP)
		
	else:
		if not is_on_floor():
			grav_vec += Vector3.DOWN * gravity * delta
			
		direction = direction.normalized()
		h_velocity = h_velocity.linear_interpolate(direction * speed, h_accel * delta)
		
		movement.z = h_velocity.z + grav_vec.z
		movement.x = h_velocity.x + grav_vec.x
		movement.y = grav_vec.y
		
		direction = Vector3.ZERO
		direction = Vector3.ZERO
		move_and_slide(movement, Vector3.UP)
		$AnimationTree.set("parameters/jump/current", 1)
	
func _on_Area_body_entered(body):
	if body.name == "Player":
		Globals.riding = true
		print(Globals.riding)
		if Globals.riding == true:
			active = true
			body.rotation_degrees.y = 0
			
			
			

func _on_Area_body_exited(body):
	if body.name == "Player":
		Globals.riding = false
		active = false
		
