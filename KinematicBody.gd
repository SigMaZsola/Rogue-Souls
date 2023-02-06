extends KinematicBody

var direction = Vector3(0,-1,0)
var minus_direction = Vector3(0,1,0)
var point = Vector3()
var stop = false
var speed = 4


var can_lift = false


func _ready():
	$lift/AnimationTree.set("parameters/st/current", 0)

func _process(delta):
	if Globals.stop == false:
		minus_direction = Vector3.ZERO
		if can_lift == true:
			direction = Vector3(0,-1,0)
			speed = 4
			yield(get_tree().create_timer(1.5), "timeout")
			move_and_slide(direction * speed)
		
	elif Globals.stop == true:
		direction = Vector3.ZERO
		if can_lift == true:
			minus_direction = Vector3(0,1,0)
			speed = 4
			yield(get_tree().create_timer(3), "timeout")
			move_and_slide(minus_direction * speed)
		
	if can_lift == false:
		direction = Vector3.ZERO
		minus_direction = Vector3.ZERO
		
	
		
	


func _on_ottmarad_body_entered(body):
	if body.name == "Player":
		$lift/AnimationTree.set("parameters/st/current", 1)
		yield(get_tree().create_timer(1), "timeout")
		can_lift = true
		body.weight_on_ground = 35


func _on_ottmarad_body_exited(body):
	if body.name == "Player":
		$lift/AnimationTree.set("parameters/st/current", 0)
		yield(get_tree().create_timer(1), "timeout")
		can_lift = false
		body.weight_on_ground = 5
		

