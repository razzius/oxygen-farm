extends MeshInstance3D

@export var min_seed: float = 0.0
@export var max_seed: float = 1.0

func _ready() -> void:
	randomize()
	print("Testing!")
	set_random_seed()

func set_random_seed() -> void:
	var material = get_material_override()
	if material:
		print("Testing2!")
		material.set_shader_parameter("seed", randf_range(min_seed, max_seed))
