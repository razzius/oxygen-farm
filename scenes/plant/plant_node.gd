extends Area2D

class_name PlantNode

const SPRITE_HEIGHT = 6
const SPRITE_WIDTH = 11
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $Collider

enum Direction {LEFT, RIGHT, UP}

const PLANT_SIZE: Vector2 = Vector2i(SPRITE_WIDTH, SPRITE_HEIGHT)
const DirectionMap: Dictionary = {
	Direction.LEFT: {
		"relative_position": Vector2i.LEFT * PLANT_SIZE.x,
		"key": "left"
	},
	Direction.RIGHT: {
		"relative_position": Vector2i.RIGHT * PLANT_SIZE.x,
		"key": "right"
	},
	Direction.UP: {
		"relative_position": Vector2i.UP * PLANT_SIZE.y,
		"key": "up"
	}
}

@export var _left: PlantNode = null
@export var _right: PlantNode = null
@export var _up: PlantNode = null

var left: PlantNode:
	get:
		return _left
	set(value):
		_left = value

var right: PlantNode:
	get:
		return _right
	set(value):
		_right = value

var up: PlantNode:
	get:
		return _up
	set(value):
		_up = value


func _ready():
	pass


func _process(_delta):
	pass


func get_leaves() -> Array[PlantNode]:
	var leaves: Array[PlantNode] = []

	if _left != null:
		leaves.append_array(_left.get_leaves())
	if _up != null:
		leaves.append_array(_up.get_leaves())
	if _right != null:
		leaves.append_array(_right.get_leaves())
	
	if (leaves.size() == 0):
		leaves.append(self)
		
	return leaves


func has_immediate_leaves() -> bool:
	return _left != null or _up != null or _right != null
	
	
func prune() -> void:
	print("pruning", self)
