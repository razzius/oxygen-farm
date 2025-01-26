extends MarginContainer

@onready var value_label: Label = $VB/MarginContainer/Value
@onready var oxy_ratio: ColorRect = $VB/OxyRatio


func _process(_delta: float) -> void:
	var ratio: float = GameStateManager.GetOxygenPercent();
	oxy_ratio.material.set_shader_parameter("Ratio", ratio);
	value_label.text = "%d%%" % int(ratio * 100)
	
	if GameStateManager.GetOxygenPercent() >= GameStateManager.Quota / 100.0:
		value_label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0))
	else:
		value_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))
