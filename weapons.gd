extends Spatial
#
#class_name Weapon
#
#
#var weapon_manager = null
#var player = null
#var animation_tree = null
#
#var is_equipped = false
#
#export var weapon_name  = "Weapon"
#
#
#
#
#func equip():
#	animation_tree.set("parameters/Equip/active", true)
#	update_ammo()
#
#func unequip():
#	animation_tree.set("parameters/Equip/active", true)
#
#func is_equppied_finished():
#	if is_equipped:
#		return true
#	else:
#		return false
#
#func is_unequppied_finished():
#	if is_equipped:
#		return false
#	else:
#		return true
#
#
#func update_ammo(action = "Refresh"):
#
#	var weapon_data = {
#		"Name" : weapon_name
#	}
#
#	weapon_manager.update_hud(weapon_data)
