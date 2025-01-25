func _ready():
	var material = get_material_override() as ShaderMaterial
	material.set_shader_parameter("seed", randf() * 10000.0)
