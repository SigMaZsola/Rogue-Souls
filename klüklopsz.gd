extends Spatial

func _process(delta):
	$AnimationTree.set("parameters/state/current", 0)
