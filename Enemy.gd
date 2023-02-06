extends KinematicBody

var swaying = false
var direction = Vector3(0,-1,0)
var coming = false
var speed = 5
var state
var target = null
var fireing = null
var can_turn = false
var can_walk = true
var bullet = preload("res://enemy/dragon/fire_detetion.tscn")

enum{
	FLYING,
	IDLE,
	WALKING,
	ALERT
}

func _ready():
	visible = false
	state = FLYING
	
func _physics_process(delta):
	

	
	
	match state:
		
		ALERT:
			if target != null:
				$dragon/Armature/Skeleton/SkeletonIK.start()
				$dragon/Armature/Skeleton/Cube/Position3D.look_at(target.global_transform.origin, Vector3.UP)
				$dragon/Armature/Skeleton/Cube/Position3D.rotation_degrees.y = clamp($dragon/Armature/Skeleton/Cube/Position3D.rotation_degrees.y, 0, 150)
				
			else:
				$dragon/Armature/Skeleton/SkeletonIK.stop()
				
		FLYING:
			if Globals.can_attack:
				if !$RayCast.is_colliding():
					visible = true
					$AnimationTree.set("parameters/state/current", 2)
					yield(get_tree().create_timer(1.5), "timeout")
					
					move_and_slide(direction * speed)
				elif $RayCast.is_colliding():
					$AnimationTree.set("parameters/state/current", 0)
					direction = Vector3.ZERO
					state = ALERT
		IDLE:
			$AnimationTree.set("parameters/state/current", 0)
			
		WALKING:
			$AnimationTree.set("parameters/state/current", 3)
			$dragon/Armature/Skeleton/SkeletonIK.stop()
			$EYES.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad($EYES.rotation.y * 2))
			direction = -global_transform.basis.z
			direction = move_and_slide(direction)

func _on_Area_body_entered(body):
	if body.name == "Player":
		swaying = true
		$AnimationTree.set("parameters/attack/current", 2)
		$AnimationTree.set("parameters/OneShot/active", true)
		yield(get_tree().create_timer(3), "timeout")
		if can_turn == true:
			rotation_degrees.y = lerp_angle(rotation_degrees.y, rotation_degrees.y + 180, 0.25)


func _on_damage_body_entered(body):
	if body.name == "Player":
		if swaying == true:
			if body.can_take_damage == true:
				body.h.value = 0
			else:
				pass


func _on_eyes_body_entered(body):
	if body.name == "Player":
		target = body
		
		

func _on_fel_body_entered(body):
	if body.name == "Player":
		$dragon/Armature/Skeleton/fej/Particles.emitting = true
		fireing = true
		while (fireing == true):
			var b = bullet.instance()
			yield(get_tree().create_timer(0.77), "timeout")
			$dragon/Armature/Skeleton/fej/Particles.add_child(b)
			b.look_at($dragon/Armature/Skeleton/fej/fire.get_collision_point(), Vector3.UP)
		
		


func _on_fel_body_exited(body):
	if body.name == "Player":
		$dragon/Armature/Skeleton/fej/Particles.emitting = false
		fireing = false
		
		


func _on_Area_body_exited(body):
	pass


func _on_butt_body_entered(body):
	if body.name == "Player":
		
		yield(get_tree().create_timer(3), "timeout")
		can_turn = true
		

func _on_butt_body_exited(body):
	if body.name == "Player":
		can_turn = false


func _on_eyes_body_exited(body):
	pass # Replace with function body.


func _on_damage_body_exited(body):
	pass # Replace with function body.


func _on_alert_body_entered(body):
	if body.name == "Player":
		pass


func _on_alert_body_exited(body):
	if body.name == "Player":
		pass


func _on_right_body_entered(body):
	pass # Replace with function body.
