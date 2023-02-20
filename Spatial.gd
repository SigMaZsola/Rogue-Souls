extends Spatial

onready var player = $Player
var default_hair_color = null
var default_skin_color = null
var default_t_color = null

var material : SpatialMaterial = null
var skin_material : SpatialMaterial = null
var t_material : SpatialMaterial = null
var inventory = false

func _ready():
	$AudioStreamPlayer.play()
	Globals.can_attack = true
	$Player.h.value = 100


	color()

func _process(delta):
	$hp/ProgressBar.value = $betterdragon/Viewport/ProgressBar.value
	if $betterdragon/Viewport/ProgressBar.value <= 0:
		$win.visible = true
		$AnimationPlayer.play("WIN")
		yield(get_tree().create_timer(121.5), "timeout")
		$win.visible = false
		get_tree().change_scene("res://MainMenu.tscn")

	else:
		$win.visible = false

func _on_Area_body_entered(body):
	if body.name == "Player":
		body.h.value = 0

func color():
	material = $Player/Mesh/Ninjon1/Armature/Skeleton/Cube.get("material/0").duplicate()
	default_hair_color = material.albedo_color
	$Player/Mesh/Ninjon1/Armature/Skeleton/Cube.set("material/0", material)
	if material.albedo_color == default_hair_color:
		material.albedo_color = Globals.hair_color

	
	skin_material = $Player/Mesh/Ninjon1/Armature/Skeleton/Cube.get("material/1").duplicate()
	default_skin_color = skin_material.albedo_color
	$Player/Mesh/Ninjon1/Armature/Skeleton/Cube.set("material/1", skin_material)
	if skin_material.albedo_color == default_skin_color:
		skin_material.albedo_color = Globals.skin_color

		
	t_material = $Player/Mesh/Ninjon1/Armature/Skeleton/Cube.get("material/6").duplicate()
	default_t_color = t_material.albedo_color
	$Player/Mesh/Ninjon1/Armature/Skeleton/Cube.set("material/6", t_material)
	if t_material.albedo_color == default_t_color:
		t_material.albedo_color = Globals.trouser_color
		
