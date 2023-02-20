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
var hp = 6000
var nyamm = false
var biting = false

#legggggg
var can_step_r = false
var can_step_l = false
var can_damage_l = false
var can_damage_r = false

var stepping = 0

var turning = false

enum{
	FLYING,
	IDLE,
	ALERT,
	BITING,
	STEPPING,
	DEAD
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
			if turning == true:
				$EYES.look_at(target.global_transform.origin, Vector3.UP)

			else:
				$EYES.look_at(target.global_transform.origin, Vector3.UP)

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
			
		DEAD:
			$AnimationTree.set("parameters/state/current", 4)

func _on_Area_body_entered(body):
	if body.name == "Player":
		yield(get_tree().create_timer(2), "timeout")
		swaying = true
		state = IDLE
		while(state == IDLE):
			$AnimationTree.set("parameters/attack/current", 2)
			$AnimationTree.set("parameters/OneShot/active", true)
			yield(get_tree().create_timer(3), "timeout")



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
			turning = false
			$Armature/Skeleton/fej/StaticBody/AudioStreamPlayer.play()
			$Armature/Skeleton/fej/Particles.emitting = true
			$AnimationTree.set("parameters/OneShot/active", true)
			for i in range(8):
				var b = bullet.instance()
				yield(get_tree().create_timer(0.2), "timeout")
				$Armature/Skeleton/fej/Particles.add_child(b)
			yield(get_tree().create_timer(0.8), "timeout")
			$Armature/Skeleton/fej/Particles.emitting = false
			turning = true


func _on_Area_body_exited(body):
	if body.name == "Player":
		state = STEPPING
		var x = 3
		swaying = false
		while(state == STEPPING):
			yield(get_tree().create_timer(1.11), "timeout")
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 3:
				yield(get_tree().create_timer(0.7), "timeout")
				if body.can_take_damage == true:
					if stepping == 1:
						body.h.value -= 40
						body.hurt()
				x += 1				
			else:
				yield(get_tree().create_timer(1), "timeout")
				if body.can_take_damage == true:
					if stepping == 2:
						body.h.value -= 40
						body.hurt()
				x -= 1
			step()
			yield(get_tree().create_timer(0.4), "timeout")
			




func _on_alert_body_entered(body):
	if body.name == "Player":
		state = BITING
		target = null
		fireing = false
		var x = 5
		yield(get_tree().create_timer(1), "timeout")
		while(state == BITING):
			nyamm = false
			$Armature/Skeleton/fej/StaticBody/bite.stop()
			yield(get_tree().create_timer(1.1), "timeout")
			$Armature/Skeleton/fej/StaticBody/bite.play()
			biting = true
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 5:
				x += 1
			else:
				x -= 1
			yield(get_tree().create_timer(0.4), "timeout")
			biting = true
			yield(get_tree().create_timer(0.6), "timeout")
			nyamm = true
			yield(get_tree().create_timer(0.6), "timeout")
			biting = false
		


func _on_alert_body_exited(body):
	if body.name == "Player":
		target = body
		state = ALERT
		fireing = true
		if $RayCast.is_colliding():
			$AnimationTree.set("parameters/attack/current", 0)
		while(fireing == true):
			$AnimationTree.set("parameters/attack/current", 0)
			yield(get_tree().create_timer(2.2), "timeout")
			turning = false
			$Armature/Skeleton/fej/StaticBody/AudioStreamPlayer.play()
			$Armature/Skeleton/fej/Particles.emitting = true
			$AnimationTree.set("parameters/OneShot/active", true)
			for i in range(10):
				var b = bullet.instance()
				yield(get_tree().create_timer(0.2), "timeout")
				$Armature/Skeleton/fej/Particles.add_child(b)
			yield(get_tree().create_timer(0.8), "timeout")
			$Armature/Skeleton/fej/Particles.emitting = false
			turning = true




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
			yield(get_tree().create_timer(1.11), "timeout")
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 3:
				yield(get_tree().create_timer(0.7), "timeout")
				if body.can_take_damage == true:
					if stepping == 1:
						body.h.value -= 40
						body.hurt()
				x += 1				
			elif x == 4:
				yield(get_tree().create_timer(1), "timeout")
				if body.can_take_damage == true:
					if stepping == 2:
						body.h.value -= 40
						body.hurt()
						print("ok")
				x -= 1
			step()
			yield(get_tree().create_timer(0.4), "timeout")


func _on_lab_body_exited(body):
	if body.name == "Player":
		state = BITING
		target = null
		fireing = false
		var x = 5
		yield(get_tree().create_timer(1), "timeout")
		while(state == BITING):
			nyamm = false
			$Armature/Skeleton/fej/StaticBody/bite.stop()
			yield(get_tree().create_timer(1.1), "timeout")
			$Armature/Skeleton/fej/StaticBody/bite.play()
			biting = true
			$AnimationTree.set("parameters/attack/current", x)
			$AnimationTree.set("parameters/OneShot/active", true)
			if x == 5:
				x += 1
			else:
				x -= 1
			yield(get_tree().create_timer(0.4), "timeout")
			biting = true
			yield(get_tree().create_timer(0.6), "timeout")
			nyamm = true
			yield(get_tree().create_timer(0.6), "timeout")
			biting = false

func _on_harap_body_entered(body):
	if body.name == "Player":
		if biting == true:
			if body.can_take_damage == true:
				body.hurt()
				body.h.value -= 20


func _on_labfej_r_body_entered(body):
	if body.name == "Player":
		stepping = 1


func _on_labfej_l_body_entered(body):
	if body.name == "Player":
		if stepping == 1 or stepping == 0:
			stepping = 2


func _on_labfej_l_body_exited(body):
	if body.name == "Player":
		stepping = 0


func _on_labfej_r_body_exited(body):
	if body.name == "Player":
		stepping = 0

func step():
	$Armature/Skeleton/lab/StaticBody/AudioStreamPlayer.play()
	yield(get_tree().create_timer(0.3), "timeout")
	$Armature/Skeleton/lab/StaticBody/AudioStreamPlayer.stop()
