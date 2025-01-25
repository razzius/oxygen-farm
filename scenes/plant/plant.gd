extends Node2D

class_name Plant

const PLANT_NODE = preload("res://scenes/plant/plant_node.tscn")

@onready var grow_timer: Timer = $GrowTimer
@onready var node_container: Node2D = $Nodes


var _plant_nodes: Array[PlantNode] = []

func _ready():
	grow()


func grow() -> void:
	appendNode()


func appendNode() -> void:
	var plant: PlantNode = PLANT_NODE.instantiate()
	plant.position = (PlantNode.relative_position * GameStateManager.NodeScale) * _plant_nodes.size()
	_plant_nodes.append(plant)
	node_container.add_child(plant)


func _on_grow_timer_timeout() -> void:
	grow()

func prune_node(starting_node: PlantNode) -> void:
	if !starting_node:
		return
	var cut_index = _plant_nodes.find(starting_node)
	for node in _plant_nodes.slice(cut_index):
		node.queue_free()
	_plant_nodes = _plant_nodes.slice(0, cut_index)