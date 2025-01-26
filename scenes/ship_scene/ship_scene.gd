extends Node2D


func _ready():
	GameStateManager.CalculateQuota()


func gather_resources():
	print("ship - gathering: %d oxygen" % GameStateManager.Quota)
	GameStateManager.CalculateQuota()
	print("ship - new quota: %d oxygen" % GameStateManager.Quota)