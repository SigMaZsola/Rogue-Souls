extends KinematicBody

var ammounation = 40

var ride = true
var ready_to_roll = false
var climbing = false

var damaging = false

var movement_speed = 0
var run_speed = 11
var walk_speed =  2.25
var crouch_walk_speed = 2.23


var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO
var active = true
var aim_turn = 0

var can_aim = false
var acceleration = 6
var vertical_velocity = 0
var gravity = 10
var angular_acceleration = 7
var roll_magnitute = 40
var jump_magnetute = -12
var slide_magnetute = 40
var weight_on_ground = 5
var can_move = true

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
var cut = "parameters/OneShot"


var puppet_position = Vector3()
var puppet_velocity = Vector3()
var puppet_rotation = Vector3()

var weapon_target = 1
var crouch_stand_target = 1
var crouch_speed = 20
#onready var weapon_manager = $Mesh/Ninjon/Armature/Skeleton/gun_attachement/Weapons
onready var pcap = $CollisionShape
onready var camera = $Camera/h/v/pivot/ClippedCamera

#health and UI stuff :(                                                                                                                                                          Nóri összejött Gyurival. :(

#onready var health_ui = $Mesh/Ninjon/Armature/Skeleton/gun_attachement/Control/TextureProgress2
var health = 100
var health_visible = false
var crouchimg = false
var camlock = false

#-----------------------------UI----------------------------------------------
var stamina = false
onready var s = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/STAMINA
onready var health_ui = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud
var time_to_wait = 2
var time_passed = 0
var time_HP = 0
var axe_time = 1
var axe_time_passed = 0
var wait_for_slash = false
onready var freeze = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/AnimationPlayer
onready var h = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/HP
var hp = false
#------------------------------------targeting---------------------------------------------------------------

var current_basis = Transform()
var rotated_basis = Transform()
var final_quat = Transform()

#-------------------------------weapon_changing-------------------------------------------------------
var current_weapon = 0
var current_armor = 0

onready var sword = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/sword
onready var unarmed = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/Unarmed
onready var axe = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/balta
onready var bow = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/ijj
onready var helmet = $Mesh/Ninjon1/Armature/Skeleton/fej/helmet

var can_slash = false
var slash_timer = 0

var can_flask = true
onready var flask = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Control/shootalbe/Label
var flasks = 5

var flask_timer = 0

onready var swordicon = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Control/sword/sword
onready var axeicon = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Control/sword/axe
onready var unarmedicon = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Control/sword/unarmed
onready var bowicon = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Control/sword/Sprite4
onready var arrow = preload("res://Weapons/arrow.tscn")
onready var ah = $Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/ijj/Spatial

var can_take_damage = true

#---------------------------------------------------targeting(i hope so)---------------------------------------------------------------------------
onready var target = null
onready var cam = $Camera/h/v/pivot/Aim_decetion
var inventory = false

#------------------------------------------fall_damage-----------------------------------------------------
var falling = false
var counter = 0
var fall_damage = 0

func hurt():
	$hurt/AnimationPlayer.play("hurt")
	$audio/aucs.play()
	yield(get_tree().create_timer(0.51), "timeout")
	$audio/aucs.stop()

func damaging():
	damaging = true
	if damaging == false:
		pass
	if damaging == true:
		$AnimationTree.set("parameters/damage/active", true)
		if $AnimationTree.set("parameters/damage/active", false):
			damaging = false



func weapon_managing():
	
	if Input.is_action_just_pressed("0"):
		current_weapon = 0
	if Input.is_action_just_pressed("empty"):
		current_weapon = 1
	if Input.is_action_just_pressed("primary"):
		current_weapon = 3
	if Input.is_action_just_pressed("secondary"):
		current_weapon = 2
			

		
	if current_weapon == 1:
		swordicon.visible = true
		if can_slash == false:
			sword.visible = true
			$AnimationTree.set("parameters/Blend2/blend_amount", 1)
			$AnimationTree.set("parameters/Blend3/blend_amount", -1)
	else:
		sword.visible = false
		swordicon.visible = false
		
	if current_weapon == 0:
		unarmed.visible = true
		unarmedicon.visible = true
		$AnimationTree.set("parameters/Blend2/blend_amount", 0)
	else:
		unarmed.visible = false
		unarmedicon.visible = false
		
	if current_weapon == 2:
		axeicon.visible = true
		if can_slash == false:
			axe.visible = true
			$AnimationTree.set("parameters/Blend2/blend_amount", 1)
			$AnimationTree.set("parameters/Blend3/blend_amount", 0)
	else:
		axeicon.visible = false
		axe.visible = false
		
	if current_weapon == 3:
		bowicon.visible = true
		bow.visible = true
		$AnimationTree.set("parameters/Blend2/blend_amount", 1)
		$AnimationTree.set("parameters/Blend3/blend_amount", 1)
		
	else:
		bow.visible = false
		bowicon.visible = false
		
	
#-------------------------------weapon_changing-------------------------------------------------------
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
			
			
		if health_visible == false:
			health_ui.visible = false
			if Input.is_action_just_pressed("TAB"):
				health_visible = true
				health_ui.visible = true
		else:
			health_ui.visible = true
			if Input.is_action_just_pressed("TAB"):
				health_visible = false
				health_ui.visible = false
		
		
				
		

func _ready():
	weapon_target = -1
	health = 100
	s.value = 100
	h.value = Globals.ph
	$Mesh/Ninjon1/Armature/Skeleton.physical_bones_start_simulation()
#	visible = !is_network_master()
#	$Camera/h/v/pivot/ClippedCamera.current = is_network_master()
	
		



func process_weapons():
	
	

			
	if flasks != 0:
		if Input.is_action_just_pressed("reload"):
			healing()
				
	
	if Input.is_action_just_pressed("fire"):
		
		if can_slash == false:
			if s.value > 0:
				if current_weapon == 1:
					swordslash()
					
				if current_weapon == 2:
					axeslash()
					
	if current_weapon == 3:
		var can_shoot = false
		if Input.is_action_pressed("aim"):
			archering()
			can_aim = true
			if ammounation != 0:
				can_shoot = true
			
			if can_shoot == true:
				s.value -= 0.5
				if Input.is_action_just_pressed("fire"):
					$audio/arrow.play()
					var b = arrow.instance()
					ammounation -= 1
					ah.add_child(b)
					b.shoot = true
					yield(get_tree().create_timer(0.4), "timeout")
					$audio/arrow.stop()
					can_shoot = false
			if can_shoot == false:
				yield(get_tree().create_timer(1), "timeout")
				can_shoot = true
			
	if Input.is_action_just_released("aim"):
		$AnimationTree.set("parameters/archering/current", 0)
		$Mesh/Ninjon1/Armature/Skeleton/SkeletonIK.stop()
		can_aim = false
		
func archering():
	if current_weapon == 3:
		
		$Mesh/Ninjon1/Armature/Skeleton/SkeletonIK.start()
		$AnimationTree.set("parameters/archering/current", 1)
		$AnimationTree.set("parameters/bowing/blend_position", 1)

		
	else:
		$Mesh/Ninjon1/Armature/Skeleton/SkeletonIK.stop()
		$AnimationTree.set("parameters/archering/current", 0)
		can_aim = false
func axeslash():
	can_slash = true
	if can_slash == true:
		var x = rand_range(0,4)
		$audio/slash.play()
		$AnimationTree.set("parameters/weapon/current", 1)
		$AnimationTree.set("parameters/Blend2/blend_amount", 0)
		$AnimationTree.set("parameters/balta/current", x)
		$AnimationTree.set("parameters/slash/active", true)
		$slash_timer.start()
		s.value -= 15
		yield(get_tree().create_timer(0.8), "timeout")
		$audio/slash.stop()
		

	
#func safe_look_at(spatial : Spatial, target: Vector3) -> void:
#	var origin : Vector3 = spatial.global_transform.origin
#	var v_z := (origin - target).normalized()
#
#	# Just return if at same position
#	if origin == target:
#		return
#
#	# Find an up vector that we can rotate around
#	var up := Vector3.ZERO
#	for entry in [Vector3.UP, Vector3.RIGHT, Vector3.BACK]:
#		var v_x : Vector3 = entry.cross(v_z).normalized()
#		if v_x.length() != 0:
#			up = entry
#			break
#
#	# Look at the target
#	if up != Vector3.ZERO:
#		spatial.look_at(target, up)

	
	
func swordslash():
	can_slash = true
	if can_slash == true:
		var x = rand_range(0,2)
		$audio/slash.play()
		$stamina.start()
		$AnimationTree.set("parameters/weapon/current", 0)
		$AnimationTree.set("parameters/Blend2/blend_amount", 0)
		$AnimationTree.set("parameters/vagas/current", x)
		$AnimationTree.set("parameters/slash/active", true)
		s.value -= 10
		$slash_timer.start()
		yield(get_tree().create_timer(0.8), "timeout")
		$audio/slash.stop()
	
#	velocity = (direction - get_floor_normal()) * 10

func swordszuras():
	$AnimationTree.set("parameters/szuras/active", true)

func healing():
	can_flask = true
	if can_flask == true:
		$AudioStreamPlayer3D.play()
		$healeffect.emitting = true
		$healeffect2.emitting = true
		current_weapon = 0
		$AnimationTree.set("parameters/heal/active", true)
		flasks -= 1
		$Mesh/Ninjon1/Armature/Skeleton/flaskattachment/flask.visible = true
		yield(get_tree().create_timer(1.6), "timeout")
		$AudioStreamPlayer3D.stop()
			
		
		
func _on_stamina_timeout():
	stamina = true
	
func _physics_process(delta):

	if is_on_floor():
		falling = false
	else:
		falling = true
		
	if falling == true:
		counter += delta
	else:
		counter += 0
		fall_damage = counter * 24
		counter = 0
		if fall_damage >= 50:
			h.value -= fall_damage
			h.value -= 7
			hurt()
#---------------------fall_damage-----------------------------------------------------------------------
	
	flask.text = str(flasks)
	Globals.can_slash = can_slash
	if can_slash == true:
		$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/balta/Particles.emitting = true
		$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/sword/Particles2.emitting = true
	elif can_slash == false:
		$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/balta/Particles.emitting = false
		$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/Weapons/sword/Particles2.emitting = false

	$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Control/shield/ColorRect/Sprite/Label.text = str(ammounation)
	
	health = Globals.ph
	if climbing == false:
		pass
	else:
		counter = 0
		if Input.is_action_pressed("előre"):
			velocity.y = 3
		if Input.is_action_pressed("hátra"):
			velocity.y = -3

	if Globals.riding == true:
		
		if ride == false:
			if Input.is_action_just_pressed("interact"):
				ride = true
				
		if ride == true:
			counter = 0
			if Input.is_action_just_pressed("interact"):
				ride = false
				
		if ride == true:
			$CollisionShape.disabled = true
			$AnimationTree.set("parameters/riding/blend_amount", 1)
			gravity = 0
			global_transform.origin = Globals.pos
			$Mesh.rotation.y = Globals.rot
			
		if ride == false:
			$CollisionShape.disabled = false
			$AnimationTree.set("parameters/riding/blend_amount", 0)
			global_transform.origin = Globals.pos1
			
		

	else:
		$CollisionShape.disabled = false
		$AnimationTree.set("parameters/riding/blend_amount", 0)
		ride = true
		
	
		if can_slash == true:
			slash_timer += delta
			if slash_timer >= 0.7:
				can_slash = false
				if can_slash == false: 
					slash_timer = 0
		if can_flask == true:
			slash_timer += delta
			if slash_timer >= 2:
				can_flask = false
				if can_flask == false: 
					slash_timer = 0
					h.value += 30
					$Mesh/Ninjon1/Armature/Skeleton/flaskattachment/flask.visible = false

		
	if active == true:
		horse_riding()
		weapon_managing()
		process_weapons()	
		
		if hp == true:
			time_HP += delta
		else:
			time_HP = 0
		
		if time_HP >= 2:
			h.value -= 20
			time_HP = 0
		
		if h.value <= 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Sprite2.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$".".active = false
		
			
			

#----------------------------------health------------------------------------------------------------
		if s.value == s.max_value:
			time_passed = 0
		
	
		if can_slash == false:
			if s.value < s.max_value:
				time_passed += delta
				
				if time_passed >= time_to_wait:
					s.value += 0.5
		else:
			s.value += 0
			
		
			
			
	
#--------------------------stamina------------------------------------------------------------------
	
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
		var fall_damage = 0
		
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
			fall_damage = 0
			
			
		fall_damage = vertical_velocity
		var time = 0
		
		if !is_on_floor():
			time += delta
			
		else:
			if time > 0:
				h.value += fall_damage
			time = 0
		
#----------------------------------AIM--------------------------------------------------------------------------------------------

		if Input.is_action_pressed("aim") && can_aim == true:
			
	#----------------------------------------------------------------------------------------------------------------------------------------------------------------
			
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
			
			
#				$EYES.look_at(target.global_transform.origin, Vector3.UP)
#				$Mesh.rotate_y(deg2rad($EYES.rotation.y * 2))
			
		else:
			
#			$Mesh/Ninjon1/Armature/Skeleton/gun_attachement/hud/Sprite3.visible = false
			Camu.camlock = false
#			$Mesh/Ninjon/Armature/Skeleton/SkeletonIK.stop()
#			$Mesh/Ninjon/Armature/Skeleton/SkeletonIK.clear_bones_global_pose_override()
#			$Camera.rotation_degrees = Vector3(0,180,0)
#			$Camera/h/v/pivot/Aim_decetion.global_transform.origin = Vector3(0,0,0)
			
			
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
					$audio/jump.play()
					vertical_velocity = jump_magnetute
					s.value -= 10
					$audio/jump.play()
					yield(get_tree().create_timer(0.5), "timeout")
					$audio/jump.stop()
				if Input.is_action_just_pressed("roll"):
					s.value -= 15
					roll()

		else:
			$AnimationTree.set(ag_transition, 0)
			$AnimationTree.set(ag_weapon_transition, 0)
			$AnimationTree.set(jump_blend, lerp($AnimationTree.get(jump_blend), vertical_velocity/jump_magnetute, delta * 10))
					
		
		
#		$AnimationTree.set(weapon_blend,lerp($AnimationTree.get(weapon_blend), weapon_target, delta * 5))
		
		
		
		
		
		aim_turn = 0
		
	else:
		pass
#		$Camera/h/v/pivot/ClippedCamera.current = false
#		$AnimationTree.active = false
#		$CollisionShape.disabled = true
#		global_transform.origin = puppet_position
#		velocity.x = puppet_velocity.x
#		velocity.y = puppet_velocity.y
#		velocity.z = puppet_velocity.z
	
	
func roll():
	if s.value > 0:
		$audio/jump.play()
		can_take_damage = false
		$AnimationTree.set("parameters/roll/active", true)
		$roll_timer.start()
		velocity = (direction - get_floor_normal()) * roll_magnitute
		yield(get_tree().create_timer(0.5), "timeout")
		$audio/jump.stop()
		

		
		
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
	
func horse_riding():

	$AnimationTree.set("parameters/riding/blend_ammount", 1)

func _on_Area_body_entered(body):
	if body.name == "Enemy":
		target = body
		can_aim = true


func _on_Area_body_exited(body):
	if body.name == "Enemy":
		target = null
		can_aim = false


func _on_roll_timer_timeout():
	can_take_damage = true

func running():
	$audio/step.play()
	yield(get_tree().create_timer(0.45), "timeout")
	$audio/step.stop()
	





