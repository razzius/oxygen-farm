extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = "solid"
	await get_tree().create_timer(2.0).timeout
	animation = "blink"
	await get_tree().create_timer(45.0).timeout
	animation = "solid"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
