extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeafPop.emitting = true
	$"Pop Particle".emitting = true
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(preload("res://scenes/menu/menu.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
