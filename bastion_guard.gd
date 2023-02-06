extends KinematicBody

var direction = Vector3()
var can_hurt = false
var target = null
var hp = 1000
var active = true

var gravity = 20
var jump = 10

var h_accel = 6
var h_velocity = Vector3()
var movement = Vector3()

var can_attack = false
var grav_vec = Vector3()
onready var particel = $Particles

enum {
	IDLE,
	ALERT,
	ATTACK,
	TURNING
	
}

var state = IDLE


func _on_Area_body_entered(body):
	if body.name == "Player":
		$AnimationTree.set("parameters/attack/current", 2)
		$AnimationTree.set("parameters/OneShot/active", true)
		state = ALERT

func _process(delta):
	$Viewport/ProgressBar.value = hp
	
	if hp <= 0:
		rotation_degrees.z = lerp_angle(rotation_degrees.z, rotation_degrees.z+90, 0.5)
		state = IDLE
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
	
	if not is_on_floor():
		grav_vec = -get_floor_normal() * gravity
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * 3, h_accel * delta)
		
	movement.z = h_velocity.z + grav_vec.z
	movement.x = h_velocity.x + grav_vec.x
	movement.y = grav_vec.y
	
		
	if active == true:
		match state:
			IDLE:
				$AnimationTree.set("parameters/state/current", 1)
			ALERT:
				$AnimationTree.set("parameters/state/current", 0)
				$AnimationTree.set("parameters/walk/blend_amount", 1)
				$EYES.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad($EYES.rotation.y * 2))
				direction = -global_transform.basis.z
				direction = move_and_slide(direction * 10)
			ATTACK:
				$AnimationTree.set("parameters/state/current", 1)
				$AnimationTree.set("parameters/walk/blend_amount", 0)
				$EYES.look_at(target.global_transform.origin, Vector3.UP)
				
				Globals.ph -= 20
	#			yield(get_tree().create_timer(3), "timeout")
	#			$AnimationTree.set("parameters/attack/active", true)
			TURNING:
				$AnimationTree.set("parameters/state/current", 1)
				$AnimationTree.set("parameters/walk/blend_amount", 0)
				$EYES.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad($EYES.rotation.y * 2))
	else:
		pass


func _on_eyes_body_entered(body):
	if body.name == "Player":
		state = ALERT
		target = body
		
		


func _on_eyes_body_exited(body):
	if body.name == "Player":
		state = IDLE
		



func _on_detection_body_entered(body):
	if body.name == "Player":
		state = TURNING


func _on_detection_body_exited(body):
	if body.name == "Player":
		
		state = ALERT




func _on_Area2_body_entered(body):
	can_attack = true
	if body.name == "Player":
		while(can_attack == true):
			$AnimationTree.set("parameters/OneShot/active", true)
			$AnimationTree.set("parameters/aa/current", 0)
			state = ATTACK
			yield(get_tree().create_timer(2), "timeout")
		


func _on_damage_body_entered(body):
	if body.name == "Player":
		if state == ATTACK:
			if body.can_take_damage == true:
				body.h.value -= 100
			else:
				pass


func _on_Area2_body_exited(body):
	can_attack = false
	if body.name == "Player":
		if state == ATTACK:
			yield(get_tree().create_timer(1), "timeout")
			state = ALERT


func _on_damage_body_exited(body):
	pass # Replace with function body.
