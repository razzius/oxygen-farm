extends AnimatedSprite2D


func _ready() -> void:
	animation = "solid"
	await get_tree().create_timer(2.0).timeout
	animation = "blink"
	await get_tree().create_timer(45.0).timeout
	animation = "solid"
