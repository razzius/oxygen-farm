extends PlantNode

class_name Plant

const PLANT_NODE = preload("res://scenes/plant/plant_node.tscn")
@onready var grow_timer: Timer = $GrowTimer
@export var node_scale: Vector2 = Vector2(1, 1)

var _plant_nodes: Array[PlantNode] = []

func _ready():
	init_root()
	SignalManager.on_plant_cut.connect(on_plant_cut)
	SignalManager.on_plant_node_cut.connect(on_plant_node_cut)


func init_root() -> void:
	var x_pos = 50
	var y_pos = NODE_SIZE.y / 2
	position = Vector2(x_pos, y_pos)
	_plant_nodes.append(self)


func should_grow() -> bool:
	return true
	# return randi() % 2 == 0


func grow() -> void:
	var should_grow_up = should_grow()
	if should_grow_up:
		add_node()


func add_node() -> void:
		var new_node = PLANT_NODE.instantiate()
		var top_node = get_top_node()
		new_node.position = top_node.position + PlantNode.relative_position * node_scale
		# wait for sprite and collider to be available, so call using deferred
		call_deferred("scale_node", new_node)
		_plant_nodes.append(new_node)
		add_child(new_node)
	

func scale_node(node: PlantNode) -> void:
	node.sprite.scale = node_scale
	node.collider.scale = node_scale

func _on_grow_timer_timeout() -> void:
	grow()
	print("root", self)
	print("root.leaves", get_top_node())
	
func get_timer() -> Timer:
	return grow_timer


# TODO: move this logic elsewhere?
func on_plant_cut(_plant: Plant) -> void:
	print("plant cut")
	# plant.queue_free()

func on_plant_node_cut(_plant_node: PlantNode) -> void:
	print("plant node cut")
	# plant_node.queue_free()


func get_top_node() -> PlantNode:
	return _plant_nodes[-1]