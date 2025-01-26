extends CanvasLayer

var _game_over: bool = false
var _can_restart: bool = false

@onready var game_over_ui: ColorRect = $MarginContainer/GameOverBg

func _ready():
	SignalManager.on_game_over.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _can_restart and Input.is_action_just_pressed("cut"):
		reset_game()


func on_game_over():
	_game_over = true
	game_over_ui.show()
	await get_tree().create_timer(1.0).timeout
	_can_restart = true

func reset_game():
	_game_over = false
	_can_restart = false
	game_over_ui.hide()
	SignalManager.on_game_reset.emit()
