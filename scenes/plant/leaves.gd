extends Node2D


func _ready() -> void:
	$LeafPop.emitting = true

func _on_timer_timeout() -> void:
	queue_free()
