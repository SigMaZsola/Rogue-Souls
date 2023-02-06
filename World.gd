extends StaticBody

onready var arrow = $Player/Camera
onready var player = $Player
var default_hair_color = null
var default_skin_color = null
var default_t_color = null

var material : SpatialMaterial = null
var skin_material : SpatialMaterial = null
var t_material : SpatialMaterial = null
var inventory = false
var dungeon = false
var can_travel = false
var can_travel_back = false


func _on_Area_body_entered(body):
	if body.name == "Player":
		body.h.value = 0


func _physics_process(delta):
	
	if $Player.h.value == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if inventory == false:
		$pause.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if Input.is_action_just_pressed("Esc"):
			inventory = true
			$pause.visible = true
	else:
		$pause.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.is_action_just_pressed("Esc"):
			inventory = false
			$pause.visible = false

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

func _ready():
	if Globals.dungeoned == false:
		$Player.global_transform.origin = $Campfire/Position3D.global_transform.origin
		

	$Player.h.value = 100
	
		
	#-----------------------------------------color------------------------------------------------------
	#color()


	
func _process(delta):
	if Globals.dungeoned == true:
		if can_travel_back == true:
			if Input.is_action_just_pressed("interact"):
				$Player.global_transform.origin = $bossroom/dungeon_area/CollisionShape.global_transform.origin
	if Input.is_action_just_pressed("interact"):
		if can_travel == true:
			$Player.global_transform.origin = $bossroom2/Position3D.global_transform.origin
	$AnimationPlayer.play("fog")
	if $Player.h.value == 0:
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()



func _on_Area2_body_entered(body):
	Globals.stop = true
	print("MEGYEN")


func _on_Area3_body_entered(body):
	if body.name == "lift":
		Globals.stop = false
		
			
	


func _on_dragon_detect_body_entered(body):
	if body.name == "Player":
		Globals.can_attack = true
		Globals.target = body
		


func _on_dungeon_area_body_entered(body):
	if body.name == "Player":
		$bossroom/dungeon_area/Label.visible = true
		can_travel = true


func _on_dungeon_area_body_exited(body):
	if body.name == "Player":
		$bossroom/dungeon_area/Label.visible = false
		can_travel = false


func _on_dungeon_detect_body_entered(body):
	if body.name == "Player":
		if Globals.dungeoned == true:
			$bossroom/dungeon_area/Label.visible = true
			can_travel_back = true


func _on_dungeon_detect_body_exited(body):
	if body.name == "Player":
		if Globals.dungeoned == true:
			$bossroom/dungeon_area/Label.visible = false
			can_travel_back = false
