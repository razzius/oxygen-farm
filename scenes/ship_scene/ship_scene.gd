extends Node2D

var iteration = 1

func _ready():
	pass
	# delay to get first quota
	# GameStateManager.CalculateQuota()


func gather_resources():
	print("ship - gathering: %d oxygen" % GameStateManager.Quota)
	if GameStateManager.GetOxygenPercent() <= GameStateManager.Quota / 100.0:
		SignalManager.on_game_over.emit("You didn't meet your quota!")
	else:
		GameStateManager.OxygenLevel -= GameStateManager.Quota * 10


func set_quota():
	GameStateManager.CalculateQuota(iteration)
	print("ship - new quota: %d oxygen" % GameStateManager.Quota)
	iteration += 1
