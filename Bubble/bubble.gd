extends Area2D

@export var new_scene: PackedScene

func _ready():
	SignalManager.on_game_reset.connect(on_game_reset)
	SignalManager.on_game_over.connect(on_game_over)

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
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 0.85, 0.05)
	tween.tween_callback(pop2)

func pop2() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 1.15, 0.05)
	tween.tween_callback(replace_children)
	SignalManager.on_bubble_popped.emit()


func _on_area_entered(area: Area2D):
	if area is PlantNode:
		pop()

func _on_body_entered(body: Node2D):
	if body is Player:
		pop()
		# This doesn't work yet -- stretch goal
		# body.velocity = -body.global_position.normalized() * 1000

func on_game_reset():
	get_tree().reload_current_scene()

func on_game_over(_message: String):
	pop()
