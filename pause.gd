extends Control

var can_click = false

func _process(delta):
	if visible == true:
		can_click = true
	if $ColorRect/Popup.can_change == true:
		if Input.is_action_just_pressed("Esc"):
			$ColorRect/Popup.can_change = false

func _on_Exit_pressed():
	if can_click:
		get_tree().change_scene("res://MainMenu.tscn")

