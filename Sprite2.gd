extends Sprite

var can_click = true

func _process(delta):
	if visible == true:
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()
			Globals.dungeoned = false
		if Input.is_action_just_pressed("Q"):
			get_tree().change_scene("res://MainMenu.tscn")
		
		
		


func _on_Button2_pressed():
	if can_click == true:
		get_tree().change_scene("res://MainMenu.tscn")


func _on_Button_pressed():
	if can_click == true:
		get_tree().reload_current_scene()
