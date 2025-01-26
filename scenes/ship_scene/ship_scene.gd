extends Node2D


func _ready():
	pass
	# delay to get first quota
	# GameStateManager.CalculateQuota()


func gather_resources():
	if GameStateManager.OxygenLevel <= GameStateManager.Quota:
		SignalManager.on_gather_failed.emit()
	print("ship - gathering: %d oxygen" % GameStateManager.Quota)
	GameStateManager.CalculateQuota()
	print("ship - new quota: %d oxygen" % GameStateManager.Quota)