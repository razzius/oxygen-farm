extends Node2D

@export var new_scene: PackedScene


func replace_children():
	# Remove all existing children
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	# Instance and add the new scene
	if new_scene:
		var instance = new_scene.instantiate()
		instance.set_global_position(Vector2(0, 0))
		add_child(instance)
	else:
		push_warning("No scene reference set for replacement")
	
func pop() -> void:
	replace_children()


func _on_area_exited(area: Node2D):
	if area is PlantNode or area is Player:
		pop()
