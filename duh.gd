extends Control

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	$Label.text = "South Duh"
	$AnimationPlayer.play("southduh")


func _on_Area_body_entered(body):
	if body.name == "Player":
		$Label.text = "North Duh"
		$AnimationPlayer.play("southduh")
