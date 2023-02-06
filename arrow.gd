extends RigidBody

var shoot = false
const damage = 50
const speed = 10
var and_its_time_to_go_now = false
var x
onready var this = $"."

func _ready():
	set_as_toplevel(true)
	var direction = Vector3()
	this.linear_velocity = -global_transform.basis.y * 500

	

	


func _on_Timer_timeout():
	queue_free()
	

func _on_Area_body_entered(body):
	
	if body.is_in_group("spider"):
		body.hp -= 10
		body.particel.emitting = true
		queue_free()
	elif body.name == "Player":
		body.h.value -= 30
		queue_free()
	else:
		queue_free()
	

	
