extends Node2D

# const LEAVES_SCENE = preload("res://")

func _ready():
	SignalManager.on_plant_node_cut.connect(OnPlantNodeCut)


func OnPlantNodeCut(node: PlantNode) -> void:
	# LEAVES_SCENE.instantiate()
	pass
