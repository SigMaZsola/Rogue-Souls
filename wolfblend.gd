extends KinematicBody

export var speed = 5
var path = []
var path_index = 0
var target = null
var velocity = Vector3.ZERO

onready var nav = get_parent()

func _physics_process(delta):
	if path.size() > 0:
		move_to_target()
	
		
		
func move_to_target():

	
	if global_transform.origin.distance_to(path[path_index]) < 0.1:
		path.remove(0)
		
	else:
		var direction = path[path_index] - global_transform.origin
		velocity = direction.normalized() * speed
		move_and_slide(velocity, Vector3.UP)
		look_at(target.global_transform.origin, Vector3.UP)
		
func get_target_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	
	


func _ready():
	yield(owner, "ready")
	target = owner.player
	


func _on_Timer_timeout():
	get_target_path(target.global_transform.origin)
