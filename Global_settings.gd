extends Node

var mouse_sens = 0.1
var fov = 70

signal bloom_toggled(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	
func toggle_vsync(value):
	OS.vsync_enabled = value
	
func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	
