extends Node

signal on_plant_node_cut(node: PlantNode)

signal on_plant_grow(plant: Plant)

signal on_plant_node_removed(position: Vector2)

signal on_jetpack_usage_changed(is_using: bool)

signal on_running_usage_changed(is_running: bool)

signal on_gather

signal on_quota_changed(quota: int)

signal on_game_over(fail_message: String)

signal on_game_reset

signal on_show_message(message: String)

signal on_full_oxygen

signal on_bubble_popped
