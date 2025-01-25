extends Area2D

class_name Plant

const PLANT_NODE = preload("res://scenes/plant/plant_node.tscn")

@onready var grow_timer: Timer = $GrowTimer
@onready var node_container: Node2D = $Nodes

@export var node_scale: Vector2 = Vector2(1, 1)

var _plant_nodes: Array[PlantNode] = []

func _ready():
	init_root()
	SignalManager.on_plant_node_cut.connect(on_plant_node_cut)


func should_grow() -> bool:
	return true
	# return randi() % 2 == 0


func init_root() -> void:
	appendNode()


func grow() -> void:
	if should_grow():
		appendNode()


func appendNode() -> void:
	var plant: PlantNode = PLANT_NODE.instantiate()
	plant.position = (PlantNode.relative_position * node_scale) * _plant_nodes.size()
	_plant_nodes.append(plant)
	node_container.add_child(plant)

func _on_grow_timer_timeout() -> void:
	grow()
	
func get_timer() -> Timer:
	return grow_timer

func on_plant_node_cut(_plant_node: PlantNode) -> void:
	print("plant node cut")
	# plant_node.queue_free()
