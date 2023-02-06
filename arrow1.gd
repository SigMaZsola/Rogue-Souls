extends RigidBody

var shoot = false
const damage = 50
const speed = 10
var and_its_time_to_go_now = false
var x

func _ready():
	set_as_toplevel(true)
	

	
func _physics_process(delta):
	apply_impulse(transform.basis.y, -transform.basis.y * 1)


func _on_Timer_timeout():
	queue_free()
	

func _on_Area_body_entered(body):
	if body.name == "Player":
		body.h.value -= 30
		queue_free()
	else:
		queue_free()
	
