extends Area2D

class_name PlantNode

const SPRITE_HEIGHT = 6
const SPRITE_WIDTH = 11
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $Collider

enum Direction {LEFT, RIGHT, UP}

const NODE_SIZE: Vector2 = Vector2i(SPRITE_WIDTH, SPRITE_HEIGHT)
const relative_position = Vector2i.UP * NODE_SIZE.y


func _ready():
	var root = get_plant_root(self)
	sprite.scale = root.node_scale
	collider.scale = root.node_scale

func get_plant_root(current_node: Node2D) -> Plant:
	var parent: Node2D = current_node.get_parent()
	return parent as Plant if parent is Plant else get_plant_root(parent)


func _process(_delta):
	pass
	
	
func prune() -> void:
	print("pruning", self)
