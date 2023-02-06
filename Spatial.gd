extends Spatial

func _ready():
	Globals.can_attack = true
	$Player.h.value = 100


func _on_Area_body_entered(body):
	if body.name == "Player":
		body.h.value = 0
