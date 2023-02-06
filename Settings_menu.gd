extends Control

#videjó
onready var display_option = $TabContainer/Video/MarginContainer/GridContainer/Displaybutton
onready var VSYNC_button = $TabContainer/Video/MarginContainer/GridContainer/Vsync_button
onready var bloom = $TabContainer/Video/MarginContainer/GridContainer/bloom_button

#audio

onready var master_vol = $TabContainer/Audio/MarginContainer/GridContainer/Master_v_slider
onready var musik_vol = $TabContainer/Audio/MarginContainer/GridContainer/Musikslider
onready var SFX = $TabContainer/Audio/MarginContainer/GridContainer/SFX_button

#Gameplay

onready var mouse_sensitivity = $TabContainer/Gameplay/mouse_sens
onready var FOV = $TabContainer/Gameplay/FOV_slider

var can_change = false

func _ready():
	pass
func _process(delta):
	if visible == true:
		can_change = true
	else:
		can_change = false
#Video


func _on_Displaybutton_item_selected(index):
	if can_change:
		GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func _on_Vsync_button_toggled(button_pressed):
	if can_change:
		GlobalSettings.toggle_vsync(button_pressed)
	
func _on_bloom_button_toggled(button_pressed):
	if can_change:
		GlobalSettings.toggle_bloom(button_pressed)


#Audio


func _on_Master_v_slider_value_changed(value):
	pass # Replace with function body.


func _on_Musikslider_value_changed(value):
	pass # Replace with function body.


func _on_SFX_button_toggled(button_pressed):
	pass # Replace with function body.

#Gameplay

func _on_mouse_sens_value_changed(value):
	GlobalSettings.mouse_sens = value
	


func _on_FOV_slider_value_changed(value):
	GlobalSettings.fov = value



