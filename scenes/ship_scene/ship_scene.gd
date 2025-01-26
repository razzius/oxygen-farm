extends Node2D

var iteration = 0

func _ready():
	pass
	# delay to get first quota
	# GameStateManager.CalculateQuota()


func gather_resources():
	if GameStateManager.OxygenLevel <= GameStateManager.Quota:
		SignalManager.on_gather_failed.emit()

	print("ship - gathering: %d oxygen" % GameStateManager.Quota)


func set_quota():
	GameStateManager.CalculateQuota(1)
	print("ship - new quota: %d oxygen" % GameStateManager.Quota)
	iteration += 1
