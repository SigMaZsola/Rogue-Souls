extends KinematicBody

var movement_speed = 0
var run_speed = 8
var walk_speed =  1.5
var crouch_walk_speed = 2.23


var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO
var active = true
var aim_turn = 0

var acceleration = 6
var vertical_velocity = 0
var gravity = 10
var angular_acceleration = 7
var roll_magnitute = 20
var jump_magnetute = -12
var slide_magnetute = 40
var weight_on_ground = 5
export var climbing = false



var ag_transition = "parameters/ag_transition/current"
var ag_weapon_transition = "parameters/ag_transition/blend_amount"
var aim_transition = "parameters/aim_transition/current"
var crouch_blend = "parameters/crouch_iw_blend/blend_amount"
var crouch_walk = "parameters/crouch_walk/blend_position"
var cs_transition = "parameters/cs_transition/current"
var iwr_blend = "parameters/iwr_blend/blend_amount"

var jump_blend = "parameters/jump_blend/blend_position"
var roll_active = "parameters/roll/active"
var blend_space = "parameters/walk/blend_position"
var weapon_blend = "parameters/weapon_blend/blend_amount"

var puppet_position = Vector3()
var puppet_velocity = Vector3()
var puppet_rotation = Vector3()

var weapon_target = 1
var crouch_stand_target = 1
var crouch_speed = 20
onready var weapon_manager = $Mesh/Nick/Armature/Skeleton/gun_attachement/Weapons
onready var pcap = $CollisionShape
onready var camera = $Camera/h/v/pivot/ClippedCamera


#health and UI stuff :(                                                                                                                                                          Nóri összejött Gyurival. :,(

#onready var health_ui = $Mesh/Nick/Armature/Skeleton/gun_attachement/Control/TextureProgress2
var health = 100
var health_visible = false
var crouchimg = false
	

func _input(event):
		
		if Input.is_action_just_pressed("switch"):
		
			var image = get_viewport().get_texture().get_data()
			image.flip_y()
			image.save_png("d:/screenshot.png")
		
		var le = camera.transform.origin.y
		if event is InputEventMouseMotion:
			aim_turn =  -event.relative.x *0.015
		if event.is_action_pressed("empty"):
			weapon_target = -1
		if event.is_action_pressed("secondary") :
			weapon_target = 1
		if event.is_action_pressed("primary"):
			weapon_target = 1 
		
		if event.is_action_pressed("gugol"):
			crouchimg = true
			le -= 10 
			crouch_stand_target = 1 - crouch_stand_target
			$AnimationTree.set(cs_transition, crouch_stand_target)
			
			
#		if health_visible == false:
#			health_ui.visible = false
#			if Input.is_action_just_pressed("TAB"):
#				health_visible = true
#				health_ui.visible = true
#		else:
#			health_ui.visible = true
#			if Input.is_action_just_pressed("TAB"):
#				health_visible = false
#				health_ui.visible = false
#		if Input.is_action_pressed("b"):
#			health_ui.value += 1 
		
				
		

func _ready():
	weapon_target = -1
	health = 100
	


func process_weapons():
#	if Input.is_action_just_pressed("empty"):
#		weapon_manager.change_weapon("Empty")
#	if Input.is_action_just_pressed("secondary"):
#		weapon_manager.change_weapon("Secondary")
#	if Input.is_action_just_pressed("primary"):
#		weapon_manager.change_weapon("Primary")
#	if Input.is_action_pressed("fire"):
#		weapon_manager.fire()
#	if Input.is_action_just_released("fire"):
#		weapon_manager.fire_stop()
#	if Input.is_action_just_pressed("reload"):
#		weapon_manager.reload()
	pass
		
func _physics_process(delta):
	if active == true:
		process_weapons()
		
		
	
		
		
		$AnimationTree.active = true
		$CollisionShape.disabled = false
		$Camera/h/v/pivot/ClippedCamera.current = true
		if climbing == false:
			vertical_velocity += gravity * delta
		else:
			vertical_velocity = 0
			if Input.is_action_pressed("előre"):
				vertical_velocity = -run_speed
			if Input.is_action_pressed("hátra"):
				vertical_velocity = run_speed
			if Input.is_action_pressed("jobbra"):
				pass
			if Input.is_action_pressed("balra"):
				pass
		
		
		
		if Input.is_action_pressed("aim"):
			$AnimationTree.set(aim_transition,0)
		else:
			$AnimationTree.set(aim_transition,1)
		
		var h_rot = $Camera/h.global_transform.basis.get_euler().y
		
		if Input.is_action_pressed("előre") || Input.is_action_pressed("hátra") || Input.is_action_pressed("jobbra") || Input.is_action_pressed("balra"):
			
			$AnimationTree.set(blend_space, lerp($AnimationTree.get(blend_space), Vector2(0,1), delta  * acceleration))
			
			direction = Vector3(Input.get_action_strength("balra") - Input.get_action_strength("jobbra"),
						0,
						Input.get_action_strength("előre") - Input.get_action_strength("hátra"))
			
			strafe_dir = direction
			
			direction = direction.rotated(Vector3.UP,h_rot).normalized()
			 
			
			if Input.is_action_pressed("sprint") && $AnimationTree.get(aim_transition) == 1 && crouch_stand_target:
				movement_speed = run_speed
				$AnimationTree.set("parameters/iwr_blend/blend_amount", lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), 1, delta * acceleration))
			else:
				if crouch_stand_target:
					movement_speed = walk_speed
				else:
					movement_speed = crouch_walk_speed
				$AnimationTree.set("parameters/iwr_blend/blend_amount", lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), 0, delta * acceleration))
				
		else:
			movement_speed = 0
			$AnimationTree.set("parameters/iwr_blend/blend_amount", lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), -1, delta * acceleration))
			$AnimationTree.set("parameters/iwr_blend/blend_amount", -1)
			strafe_dir = Vector3.ZERO
			
			if $AnimationTree.get("parameters/aim_transition/current") == 0:
				direction = $Camera/h.global_transform.basis.z
		
			
		
			
		velocity = lerp(velocity, direction * movement_speed, delta * acceleration)
		move_and_slide(velocity + Vector3.DOWN * vertical_velocity - get_floor_normal() * weight_on_ground, Vector3.UP)
		
		if !is_on_floor():
			vertical_velocity += gravity * delta
			
			if $Mesh/RayCast.is_colliding():
				if $Mesh/RayCast2.is_colliding():
					pass
					
				else:
					vertical_velocity = 0
					gravity = 0
					if Input.is_action_pressed("jump"):
						vertical_velocity -= 10
			else:
				gravity = 10
		else:
			vertical_velocity = 0

		if Input.is_action_pressed("aim") && !$AnimationTree.get("parameters/roll/active") && weapon_target == 1:
			$Mesh/Nick/Armature/Skeleton/SkeletonIK.start()
			
			if $AnimationTree.get(aim_transition) == 1:
				$AnimationTree.set(aim_transition, 0)
				$AnimationTree.set("parameters/neck_front/blend_amount", 1)
				
				
			if $AnimationTree.get(roll_active):
				$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
			else:
				$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * angular_acceleration)
				
			strafe = lerp(strafe, strafe_dir + Vector3.RIGHT * aim_turn,delta * acceleration)

			$AnimationTree.set("parameters/walk/blend_position", Vector2(-strafe.x, strafe.z))
			$AnimationTree.set(crouch_walk, Vector2(-strafe.x, strafe.z))
			
			$AnimationTree.set(iwr_blend, lerp($AnimationTree.get(iwr_blend), 0, delta * acceleration))
			$AnimationTree.set("parameters/crouch_iw_blend/blend_amount", lerp($AnimationTree.get("parameters/crouch_iw_blend/blend_amount"), 1, delta * acceleration))
			
		else:
#			$Mesh/Nick/Armature/Skeleton/SkeletonIK.stop()
#			$Mesh/Nick/Armature/Skeleton.clear_bones_global_pose_override()
			if $AnimationTree.get(aim_transition) == 0:
				$AnimationTree.set(aim_transition, 1)
				
				
				$AnimationTree.set("parameters/neck_front/blend_amount", 0)
				
			$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
			
			$AnimationTree.set(blend_space, lerp($AnimationTree.get(blend_space), Vector2(0,0), delta  * acceleration))
			$AnimationTree.set(crouch_walk, lerp($AnimationTree.get(crouch_walk), Vector2(0,1), delta  * acceleration))
			
			
			var iw_blend = (velocity.length() - walk_speed)/ walk_speed
			var wr_blend = (velocity.length() - walk_speed)/ (run_speed - walk_speed)
		
			if velocity.length() <= walk_speed:
				$AnimationTree.set(iwr_blend, iw_blend)
				$AnimationTree.set(iwr_blend, 0)
			else:
				$AnimationTree.set(iwr_blend, wr_blend)
				$AnimationTree.set(iwr_blend, wr_blend)
				
		$AnimationTree.set("parameters/crouch_iw_blend/blend_amount", velocity.length()/crouch_walk_speed)
		
		
		if is_on_floor():
			
			$AnimationTree.set(ag_transition, 1)
			$AnimationTree.set(ag_weapon_transition, crouch_stand_target)
			
			if !$AnimationTree.get("parameters/roll/active"):
				if Input.is_action_just_pressed("jump"):
					vertical_velocity = jump_magnetute
				if Input.is_action_just_pressed("roll"):
					roll()
		else:
			$AnimationTree.set(ag_transition, 0)
			$AnimationTree.set(ag_weapon_transition, 0)
			
			$AnimationTree.set(jump_blend, lerp($AnimationTree.get(jump_blend), vertical_velocity/jump_magnetute, delta * 10))
					
		
		
		$AnimationTree.set(weapon_blend,lerp($AnimationTree.get(weapon_blend), weapon_target, delta * 5))
		
		
		
		
		
		aim_turn = 0
		
	else:
		$Camera/h/v/pivot/ClippedCamera.current = false
		$AnimationTree.active = false
		$CollisionShape.disabled = true
#		global_transform.origin = puppet_position
#		velocity.x = puppet_velocity.x
#		velocity.y = puppet_velocity.y
#		velocity.z = puppet_velocity.z
	
	
func roll():
	$AnimationTree.set("parameters/roll/active", true)
	$roll_timer.start()
	velocity = (direction - get_floor_normal()) * roll_magnitute
	


#func _on_fall_timer_timeout():
#	if is_on_floor():
#		roll()
		
		
func aim():
	$CamAnimation.play("aim")
	if $CamAnimation.play("aim"):
		$CamAnimation.stop()
	
func not_aim():
	$CamAnimation.play_backwards("aim")
	
		


#func _on_Timer_timeout():
#	if is_network_master() and name == str(get_tree().get_network_unique_id()):
#		rpc_unreliable("update_state", global_transform.origin, velocity, Vector2($Mesh.rotation.x, rotation))


func _on_Back_pressed():
	
	$".".queue_free()
