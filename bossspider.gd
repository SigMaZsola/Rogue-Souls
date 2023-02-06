extends KinematicBody

var active = true
export var hp = 300
var can_move = true
var can_attack = false

export var speed = 3

var target = null
var direction = Vector3()

onready var particel = $Particles
export var poison = preload("res://poison.tscn")

enum {
	IDLE,
	ALERT,
	ATTACK
	
}

var state = IDLE


func _on_Area_body_entered(body):
	if body.name == "Player":
		$AnimationTree.set("parameters/state/current", 1)
		state = ALERT
		target = body
		

func _process(delta):	
	$Viewport/ProgressBar.value = hp
	if hp > 0:
		active = true
	elif hp <= 0:
		Globals.dungeoned = true
		$win.visible = true
		$AnimationPlayer2.play("enemy_defeated")
		yield(get_tree().create_timer(3), "timeout")
		$AnimationPlayer2.stop()
		rotation_degrees.z = lerp_angle(rotation_degrees.z, rotation_degrees.z+90, 0.5)
		state = IDLE
		yield(get_tree().create_timer(0.6), "timeout")
		queue_free()

		
	
	if active == true:
		match state:
			IDLE:
				$AnimationTree.set("parameters/state/current", 0)
			ALERT:
				if can_move:
					
					$EYES.look_at(target.global_transform.origin, Vector3.UP)
					rotate_y(deg2rad($EYES.rotation.y * 2))
					direction = -global_transform.basis.z
					direction = move_and_slide(direction * speed)
					$AnimationTree.set("parameters/state/current", 1)
					
#					while(can_move):
#						yield(get_tree().create_timer(1), "timeout")
#						var b = poison.instance()
#						yield(get_tree().create_timer(1), "timeout")
#						$Armature/Skeleton/head/Position3D.add_child(b)

			ATTACK:
				if can_move == false:
					$EYES.look_at(target.global_transform.origin, Vector3.UP)
					
					$AnimationTree.set("parameters/state/current", 0)
					



func _on_Area2_body_entered(body):
	if body.name == "Player":
		state = ATTACK
		can_move = false
		can_attack = true
		while(can_attack == true):
			
			$AnimationTree.set("parameters/attack/current", 1)
			$AnimationTree.set("parameters/OneShot/active", true)
			yield(get_tree().create_timer(1), "timeout")
			

func _on_Area3_body_entered(body):
	if body.name == "Player":
		state = ALERT
		$AnimationTree.set("parameters/attack/current", 2)
		$AnimationTree.set("parameters/OneShot/active", true)


func _on_Area4_body_entered(body):
	if body.name == "Player":
		state = ATTACK


func _on_Area4_body_exited(body):
	if body.name == "Player":
		state = ALERT


func _on_Area2_body_exited(body):
	if body.name == "Player":
		can_attack = false
		yield(get_tree().create_timer(1), "timeout")
		state = ALERT
		can_move = true
		




func _on_spice_body_entered(body):
	if can_attack == true:
		if body.name == "Player":
			if body.can_take_damage == true:
				body.h.value -= 60
				body.hurt()
			else:
				pass


