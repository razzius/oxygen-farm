extends CanvasLayer

var _game_over: bool = false
var _can_input: bool = false

@onready var game_over_ui: ColorRect = $MarginContainer/GameOverBg
@onready var game_over_message: Label = $MarginContainer/GameOverBg/VBoxContainer/FailureMessage

func _ready():
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_quota_changed.connect(on_quota_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _can_input and Input.is_action_just_pressed("cut"):
		reset_game()
	if _can_input and Input.is_action_just_pressed("escape"):
		get_tree().quit()


func on_game_over(fail_message: String):
	_game_over = true
	game_over_message.text = fail_message
	await get_tree().create_timer(.75).timeout
	game_over_ui.show()
	await get_tree().create_timer(1.0).timeout
	_can_input = true

func reset_game():
	_game_over = false
	_can_input = false
	game_over_ui.hide()
	SignalManager.on_game_reset.emit()

func on_quota_changed(new_quota: int) -> void:
	# update UI to show new quota
	print("hud -- new quota: %d" % new_quota)
