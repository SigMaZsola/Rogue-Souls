extends Control


func _ready():
	$AnimationPlayer.play("intro")
	yield(get_tree().create_timer(2), "timeout")
	$intro.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Start_pressed():
	Globals.dungeoned = false
	get_tree().change_scene("res://costumization.tscn")





func _on_Exit_pressed():
	get_tree().quit()





func _on_Button_pressed():
	pass # Replace with function body.


func _on_Credits_pressed():
	get_tree().change_scene("res://credits.tscn")


func _on_Settings_pressed():
	get_tree().change_scene("res://Settings_with_back.tscn")
