extends Label

const ANIM_TIME: float = 60
const PICKUP_TIME_FROM_ANIM_START: float = 35
var _time_left: float = PICKUP_TIME_FROM_ANIM_START
var _timer_running = false

var _counter: int = 0

func _ready():
	SignalManager.on_quota_changed.connect(on_quota_changed)
	SignalManager.on_game_over.connect(on_game_over)


func _process(_delta):
	if _timer_running:
		_time_left -= _delta
		text = "Pickup in %ds" % ceil(_time_left)


func on_quota_changed(_quota: int) -> void:
	show()
	_time_left = 0.0
	_timer_running = true
	_time_left = PICKUP_TIME_FROM_ANIM_START if _counter == 0 else ANIM_TIME

func on_game_over(_message: String):
	_time_left = 0.0
	_timer_running = false
	hide()
