extends ColorRect


func _process(_delta: float) -> void:
	var ratio: float = GameStateManager.GetOxygenPercent();
	material.set_shader_parameter("Ratio", ratio);
