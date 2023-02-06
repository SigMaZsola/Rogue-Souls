extends Spatial


var done = false

func _ready():
	$tuti/Label.text = "Press [TAB] to show status"


func _physics_process(delta):
	if done == false:
		if Input.is_action_just_pressed("TAB"):
			$tuti/Label.text = "Press [SPACE] to jump"
		if Input.is_action_just_pressed("jump"):
			$tuti/Label.text = "Press [W] to move forward, [S] to backward, [A] to left, and [S] to right!"
			yield(get_tree().create_timer(4), "timeout")
			$tuti/Label.text = "Press [SHIFT] to sprint"
			yield(get_tree().create_timer(4), "timeout")
			done = true
	if done == true:
		$tuti/Label.text = "Jump on the platforms, and reach the gate!"
			


func _on_dead_body_entered(body):
	if body.name == "Player":
		body.h.value = 0
