extends Node2D

@onready var timer: Timer = $QuotaTimer

func _on_quota_timer_timeout() -> void:
	GameStateManager.CalculateQuota()
	timer.start()
