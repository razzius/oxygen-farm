extends Node2D

var QuotaTimeDuration : float = 60.0
@onready var QuotaTimer : Timer = $QuotaTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quota_timer_timeout() -> void:
	QuotaTimer.start()
	QuotaTimer.wait_time = 60.0
