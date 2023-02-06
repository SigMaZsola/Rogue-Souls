extends Spatial

var material : SpatialMaterial = null
var default_hair_color = null
var other_hair_color = null
var skin_default_color = null
var default_skin_color = null
var default_trouser_color = null
var other_skin_color = null
var other_trouser_color = null
var changed = false

enum {
	SKIN,
	HAIR,
	TROUSERS
}

var colors = HAIR

func _ready():
	$Player.active = false
	$Player/Mesh/Ninjon1/Armature/Skeleton/inventory.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _process(delta):
	match colors:
		HAIR:
			material = $Player/Mesh/Ninjon1/Armature/Skeleton/Cube.get("material/0").duplicate()
			default_hair_color = material.albedo_color
			$Player/Mesh/Ninjon1/Armature/Skeleton/Cube.set("material/0", material)
			if Input.is_action_just_pressed("aim"):
				if changed == true:
					change_color()
		SKIN:
			material = $Player/Mesh/Ninjon1/Armature/Skeleton/Cube.get("material/1").duplicate()
			default_skin_color = material.albedo_color
			$Player/Mesh/Ninjon1/Armature/Skeleton/Cube.set("material/1", material)
			if Input.is_action_just_pressed("aim"):
				if changed == true:
					change_color()
		TROUSERS:
			material = $Player/Mesh/Ninjon1/Armature/Skeleton/Cube.get("material/6").duplicate()
			default_trouser_color = material.albedo_color
			$Player/Mesh/Ninjon1/Armature/Skeleton/Cube.set("material/6", material)
			if Input.is_action_just_pressed("aim"):
				if changed == true:
					change_color()

	
	
	
func change_color():
	match colors:
		HAIR:
			if material.albedo_color == default_hair_color:
				material.albedo_color = other_hair_color
				Globals.hair_color = other_hair_color
			else:
				pass
		SKIN:
			if material.albedo_color == default_skin_color:
				material.albedo_color = other_skin_color
				Globals.trouser_color = other_skin_color
			else:
				pass
		TROUSERS:
			if material.albedo_color == default_trouser_color:
				material.albedo_color = other_trouser_color
				Globals.trouser_color = other_trouser_color
			else:
				pass
			
			

func _on_ColorPickerButton_color_changed(color):
	colors = HAIR
	other_hair_color = color
	Globals.hair_color = color
	changed = true


func _on_ColorPickerButton2_color_changed(color):
	colors = SKIN
	other_skin_color = color
	Globals.skin_color = color
	changed = true


func _on_ColorPickerButton3_color_changed(color):
	colors = TROUSERS
	other_trouser_color = color
	Globals.trouser_color = color
	changed = true


func _on_Button_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_Button2_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
