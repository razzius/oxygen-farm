extends Node2D

class_name PlantManager

@onready var timer: Timer = $Timer
@export var left_bound: Node2D
@export var right_bound: Node2D

@export var node_scale: Vector2 = Vector2(3, 3)

const PLANT = preload("res://scenes/plant/plant.tscn")

var _min_x: float;
var _max_x: float;
var _plant_width: float
var _gap: float
var _max_plants: int

var _plants: Array[Plant] = []
var _available_plots: Array = []

func _ready():
	SignalManager.on_plant_node_cut.connect(on_plant_node_cut)
	GameStateManager.NodeScale = node_scale
	_min_x = left_bound.position.x
	_max_x = right_bound.position.x
	_plant_width = PlantNode.SPRITE_WIDTH * node_scale.x
	_gap = PlantNode.SPRITE_WIDTH * node_scale.x
	_max_plants = floori((_max_x - _min_x) / (_plant_width + _gap))
	_available_plots = range(_max_plants)
	for i in range(_max_plants):
		_plants.append(null)


func _on_timer_timeout():
	if _available_plots.size() == 0:
		return
	var plant: Plant = PLANT.instantiate()
	plant.position = get_random_pos()
	_plants.append(plant)
	add_child(plant)
	timer.start()

func get_random_pos() -> Vector2:
	var insert_index = _available_plots.pick_random()
	var remove_index = _available_plots.find(insert_index)
	_available_plots.remove_at(remove_index)
	return Vector2(_min_x + insert_index * (_plant_width + _gap), 0)


func on_plant_node_cut(plant_node: PlantNode) -> void:
	var plant = plant_node.get_plant_root()
	plant.prune_node(plant_node)