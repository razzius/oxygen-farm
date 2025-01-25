extends Area2D

class_name PlantNode

var _left: PlantNode = null
var _right: PlantNode = null
var _up: PlantNode = null

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
