extends Node2D

class_name Plant

const PLANT_NODE = preload("res://scenes/plant/plant_node.tscn")

@onready var grow_timer: Timer = $GrowTimer
@onready var node_container: Node2D = $Nodes

@export var grow_timer_range: float = 0.3
@export var min_grow_timer: float = 0.5


var _plant_nodes: Array[PlantNode] = []

func _ready():
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_full_oxygen.connect(on_full_oxygen)
	grow()


func get_nodes() -> Array[PlantNode]:
	return _plant_nodes


func grow() -> void:
	appendNode()
	SignalManager.on_plant_grow.emit()
	grow_timer.wait_time = min_grow_timer + (randf() * grow_timer_range)
	grow_timer.start()


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

func get_first_node() -> PlantNode:
	return null if _plant_nodes.size() == 0 else _plant_nodes[0]


func on_game_over(_message: String):
	queue_free()

func on_full_oxygen() -> void:
	queue_free()
