extends Node2D

class_name PlantManager

@onready var timer: Timer = $Timer
@export var left_bound: Node2D
@export var right_bound: Node2D

const PLANT = preload("res://scenes/plant/plant.tscn")

var _min_x: float;
var _max_x: float;
var _plant_width: float
var _gap: float
var _max_plants: int

var _plants: Array[Plant] = []

func _ready():
	_min_x = left_bound.position.x
	_max_x = right_bound.position.x
	_plant_width = PlantNode.SPRITE_WIDTH * plant.node_scale.x
	_gap = PlantNode.SPRITE_WIDTH * plant.node_scale.x
	_max_plants = floori((_max_x - _min_x) / (_plant_width + _gap))
	print("plant manager ready")
	pass # Replace with function body.


func _on_timer_timeout():
	print("timer timeout")
	var plant: Plant = PLANT.instantiate()
	plant.position = get_random_pos(plant)
	_plants.append(plant)
	add_child(plant)
	timer.start()

func get_random_pos(plant: Plant) -> Vector2:


	print(max_count)
	return Vector2(0, 0)
