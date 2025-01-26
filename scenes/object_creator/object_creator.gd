extends Node2D

const LEAVES_SCENE = preload("res://scenes/plant/Leaves.tscn")

func _ready():
	SignalManager.on_plant_node_removed.connect(OnPlantNodeRemoved)


func OnPlantNodeRemoved(pos: Vector2) -> void:
	if !GameStateManager.ShouldCreatePlantParticles:
		return

	if get_tree() == null:
		return
		
	if get_tree().root == null:
		return
		
	var leaves = LEAVES_SCENE.instantiate()
	
	if leaves == null:
		return
	
	get_tree().root.add_child(leaves)
	leaves.global_position = pos
