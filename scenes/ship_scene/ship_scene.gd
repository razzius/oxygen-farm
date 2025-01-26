extends Node2D

var iteration = 2

func _ready():
	await get_tree().create_timer(5.0).timeout
	GameStateManager.CalculateQuota(1)

func gather_resources():
	GameStateManager.GatherOxygen()
	GameStateManager.CalculateQuota(iteration)
	iteration += 1
