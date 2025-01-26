extends Area2D

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


func _on_area_entered(area: Area2D):
	if area is PlantNode:
		pop()
		# GameManager.end_game()

func _on_body_entered(body: Node2D):
	if body is Player:
		pop()
		# This doesn't work yet -- stretch goal
		# body.velocity = -body.global_position.normalized() * 1000
