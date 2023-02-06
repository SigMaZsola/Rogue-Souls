extends WorldEnvironment

func _ready():
	environment.fog_enabled = true
	GlobalSettings.connect("bloom_toggled", self, "_on_bloom_toggled")


func _on_dungeon_body_entered(body):
	if body.name == "Player":
		environment.fog_enabled = false


func _on_dungeon_body_exited(body):
		if body.name == "Player":
			environment.fog_enabled = true
			
func _on_bloom_toggled(value):
	environment.glow_enabled = value
