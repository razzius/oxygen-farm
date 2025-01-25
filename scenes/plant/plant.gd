extends Node2D

class_name Plant

const PLANT_NODE = preload("res://scenes/plant/plant_node.tscn")
@onready var grow_timer: Timer = $GrowTimer
@export var node_scale: Vector2 = Vector2(1, 1)

var _root: PlantNode

func _ready():
	_root = PlantNode.new()
	_root.position = Vector2(50, 0)
	add_child(_root)


func should_grow() -> bool:
	return true
	# return randi() % 2 == 0
func grow() -> void:
	var leaves = _root.get_leaves()
	for leaf in leaves:
		# var should_grow_left = should_grow()
		# var should_grow_right = should_grow()
		var should_grow_up = should_grow()
		if should_grow_up:
			add_node(leaf, [PlantNode.Direction.UP])


func add_node(source: PlantNode, directions: Array[PlantNode.Direction]) -> void:
	for dir in directions:
		var new_node = PLANT_NODE.instantiate()
		var dir_info = PlantNode.DirectionMap[dir]
		new_node.position = source.position + dir_info["relative_position"] * node_scale
		# wait for sprite and collider to be available, so call using deferred
		call_deferred("scale_node", new_node)
		source[dir_info.key] = new_node
		if (dir == PlantNode.Direction.UP):
			_root.add_child(new_node)
		else:
			source.add_child(new_node)
	

func scale_node(node: PlantNode) -> void:
	node.sprite.scale = node_scale
	node.collider.scale = node_scale

func _on_grow_timer_timeout() -> void:
	grow()
	print("root", _root)
	print("root.leaves", _root.get_leaves())
	
func get_timer() -> Timer:
	return grow_timer
