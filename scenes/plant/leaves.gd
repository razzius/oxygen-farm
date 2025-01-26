extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeafPop.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()
