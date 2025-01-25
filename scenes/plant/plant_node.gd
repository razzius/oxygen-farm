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
	pass


func _process(_delta):
	pass
	
	
func prune() -> void:
	print("pruning", self)
