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
var anim_activ = false

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
	
	if $RayCast.is_colliding():
		pass
	elif !$RayCast.is_colliding():
		if state == ALERT:
			state = IDLE
#		if target != null:
#			state = ALERT

	
	$Viewport/ProgressBar.value = hp
	
	if hp <= 0:
		rotation_degrees.z = lerp_angle(rotation_degrees.z, rotation_degrees.z+90, 0.5)
		state = IDLE
		yield(get_tree().create_timer(1), "timeout")
		$CollisionShape.disabled = true
		visible = false
		active = false


	
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
				if target != null:
					$AnimationTree.set("parameters/state/current", 0)
					$AnimationTree.set("parameters/walk/blend_amount", 1)
					$EYES.look_at(target.global_transform.origin, Vector3.UP)
					rotate_y(deg2rad($EYES.rotation.y * 2))
					direction = -global_transform.basis.z
					direction = move_and_slide(direction * 20)
			ATTACK:
				if target != null:
					$AnimationTree.set("parameters/state/current", 1)
					$AnimationTree.set("parameters/walk/blend_amount", 0)
					$EYES.look_at(target.global_transform.origin, Vector3.UP)
					
					Globals.ph -= 20
	#			yield(get_tree().create_timer(3), "timeout")
	#			$AnimationTree.set("parameters/attack/active", true)
			TURNING:
				if target != null:
					$AnimationTree.set("parameters/state/current", 2)
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
		target = null
		
		



func _on_detection_body_entered(body):
	if body.name == "Player":
		state = TURNING


func _on_detection_body_exited(body):
	if body.name == "Player":
		yield(get_tree().create_timer(1.44567), "timeout")
		state = ALERT


func _on_Area2_body_entered(body):
	if body.name == "Player":
		can_attack = true
		while(can_attack == true):
			yield(get_tree().create_timer(1), "timeout")
			$AnimationTree.set("parameters/OneShot/active", true)
			yield(get_tree().create_timer(0.5), "timeout")
			if can_hurt == true:
				if body.can_take_damage == true:
					body.hurt()
					body.h.value -= 40
			$AnimationTree.set("parameters/aa/current", 0)
			state = TURNING
			
	else:
		can_attack = false



func _on_Area2_body_exited(body):
	if body.name == "Player":
		can_attack = false


func _on_damage_body_entered(body):
	if body.name == "Player":
		can_hurt = true
	
	
func _on_damage_body_exited(body):
	if body.name == "Player":
		can_hurt = false


func _on_die_timeout():
	pass # Replace with function body.
