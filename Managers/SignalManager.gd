extends Node

signal on_plant_node_cut(node: PlantNode)

signal on_plant_grow(plant: Plant)

signal on_plant_node_removed(position : Vector2)

signal on_jetpack_usage_changed(is_using : bool)

signal on_running_usage_changed(is_running : bool)
