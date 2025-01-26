extends Label

const ANIM_TIME: float = 60
const PICKUP_TIME_FROM_ANIM_START: float = 35
var _time_left: float = PICKUP_TIME_FROM_ANIM_START
var _timer_running = false

func _ready():
	SignalManager.on_quota_changed.connect(on_quota_changed)
	SignalManager.on_gather.connect(on_gather)
	SignalManager.on_game_over.connect(on_game_over)


func _process(_delta):
	if _timer_running:
		_time_left -= _delta
		text = "Pickup in %ds" % ceil(_time_left)


func on_quota_changed(_quota: int) -> void:
	_timer_running = true
	show()

func on_gather():
	_time_left = ANIM_TIME


func on_game_over(_message: String):
	_time_left = 0.0
	_timer_running = false
	hide()
