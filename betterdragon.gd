extends KinematicBody

var swaying = false
var direction = Vector3(0,-1,0)
var coming = false
var speed = 5
var state
var target = null
var fireing = false
var can_turn = false
var can_walk = true
var can_step = false
var bullet = preload("res://enemy/dragon/fire_detetion.tscn")
var hp = 3000



#legggggg
var can_step_r = false
var can_step_l = false
var can_damage_l = false
var can_damage_r = false

enum{
	FLYING,
	IDLE,
	ALERT,
	BITING,
	STEPPING
}

func _ready():
	visible = false
	state = FLYING


			

func _physics_process(delta):
	$Viewport/ProgressBar.value = $Armature/Skeleton/fej/StaticBody.hp + $Armature/Skeleton/gerinc/StaticBody.hp + $Armature/Skeleton/lab/StaticBody.hp + $Armature/Skeleton/lab2/StaticBody.hp
	
	if can_turn == true:
		$AnimationTree.set("parameters/state/current", 3)
	else:
		$AnimationTree.set("parameters/state/current", 0)
	
	match state:
		
		ALERT:

			$AnimationTree.set("parameters/state/current", 0)
			$AnimationTree.set("parameters/attack/current", 0)
		
		BITING:
			fireing = false
			$AnimationTree.set("parameters/state/current", 0)
			$Armature/Skeleton/SkeletonIK.stop()
		STEPPING:
			fireing = false
			$AnimationTree.set("parameters/state/current", 1)
			$Armature/Skeleton/SkeletonIK.stop()
		
			
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

		IDLE:
			target = null
			$AnimationTree.set("parameters/state/current", 0)
			$Armature/Skeleton/SkeletonIK.stop()
			fireing = false
			

func _on_Area_body_entered(body):
	if body.name == "Player":
		swaying = true
		state = IDLE
		var x = int(rand_range(1,3))
		while(swaying == true):
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			yield(get_tree().create_timer(2), "timeout")


func _on_damage_body_entered(body):
	if body.name == "Player":
		swaying = true
		fireing = false
		if swaying == true:
			if body.can_take_damage == true:
				body.h.value = 0
				body.hurt()
			else:
				pass


func _on_eyes_body_entered(body):
	if body.name == "Player":
		target = body
		fireing = true
		state = ALERT

		while(fireing == true):
			$AnimationTree.set("parameters/attack/current", 0)
			yield(get_tree().create_timer(2), "timeout")
			$Armature/Skeleton/fej/Particles.emitting = true
			$AnimationTree.set("parameters/OneShot/active", true)
			yield(get_tree().create_timer(3), "timeout")
			$Armature/Skeleton/fej/Particles.emitting = false
		
				
				
				

		
		


func _on_Area_body_exited(body):
	if body.name == "Player":
		swaying = false



func _on_alert_body_entered(body):
	if body.name == "Player":
		state = BITING
		target = null
		fireing = false
		var x = 5
		yield(get_tree().create_timer(1), "timeout")
		while(state == BITING):
			yield(get_tree().create_timer(2.22), "timeout")
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 5:
				x += 1
			else:
				x -= 1
		


func _on_alert_body_exited(body):
	if body.name == "Player":
		target = body
		state = ALERT
		fireing = true
		if $RayCast.is_colliding():
			$AnimationTree.set("parameters/attack/current", 0)
		while(fireing == true):
			yield(get_tree().create_timer(2), "timeout")
			can_turn = false
			$Armature/Skeleton/fej/Particles.emitting = true
			$AnimationTree.set("parameters/OneShot/active", true)
			yield(get_tree().create_timer(3), "timeout")
			$Armature/Skeleton/fej/Particles.emitting = false
			can_turn = true



func _on_eyes_body_exited(body):
	if body.name == "Player":
		state = IDLE
		can_step = true
		



func _on_lab_body_entered(body):
	if body.name == "Player":
		state = STEPPING
		var x = 3
		yield(get_tree().create_timer(1), "timeout")
		while(state == STEPPING):
			yield(get_tree().create_timer(2.22), "timeout")
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 3:
				x += 1
			else:
				x -= 1


func _on_lab_body_exited(body):
	if body.name == "Player":
		state = BITING
		target = null
		fireing = false
		var x = 5
		yield(get_tree().create_timer(1), "timeout")
		while(state == BITING):
			yield(get_tree().create_timer(2.22), "timeout")
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 5:
				x += 1
			else:
				x -= 1
