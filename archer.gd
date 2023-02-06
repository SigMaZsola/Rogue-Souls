extends StaticBody

onready var particel = $Particles
var target = null
var attack = false
export var bullet = preload("res://Weapons/arrow1.tscn")
var hp = 5

func _ready():
	$body/house/Particles.emitting = false

func _process(delta):
	
	if attack:
		$EYES.look_at(target.global_transform.origin, Vector3.UP)
		rotate_y(deg2rad($EYES.rotation.y * 20))
		
		
	if hp <= 0:
		die()
		yield(get_tree().create_timer(0.6), "timeout")
		$AnimationPlayer.stop()
		visible = false
		attack = false
		


func _on_Area_body_entered(body):
	if body.name == "Player":
		$body/house/Particles.emitting = true
		target = body
		attack = true
		
		while (attack == true):
			yield(get_tree().create_timer(1), "timeout")
			var b = bullet.instance()
			yield(get_tree().create_timer(1), "timeout")
			$EYES/Position3D.add_child(b)
			
		
			
func die():
	attack = false
	$body/house/Particles.emitting = false
	$CollisionShape.disabled = true
	$AnimationPlayer.play("die")
	
			
			


func _on_Area_body_exited(body):
	if body.name == "Player":
		$body/house/Particles.emitting = false
		attack = false
		target = null
