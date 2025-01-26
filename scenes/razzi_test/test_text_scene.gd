extends Control

const SPEED = 0.1

@onready var message_label: Label = $Message
@onready var timer: Timer = $Timer

func _ready() -> void:
	SignalManager.on_show_message.connect(write_message)
	SignalManager.on_game_over.connect(on_game_over)
	timer.set_wait_time(SPEED)
	# write_intro_messages()


func delay(repeats = 1):
	for _i in repeats:
		timer.start()
		await timer.timeout


var MESSAGES = [
	"""GOOD MORNING
young oxygenfarmer...""",
	"""What is your name?
Oh, BRANDY is your name?""",
	"It is a good name.",
	"""WELCOME to
sub-planet X-AB_JXT.""",
	"""As you can see, the flora here is lively."""
]


func write_message(message: String):
	print("Writing meassage:", message)
	message_label.text = ""

	for char_ in message:
		if char_ == "\n":
			await delay(4)

		elif char_ != " ":
			await delay()

		message_label.text += char_


# func write_intro_messages():
# 	for message in MESSAGES:
# 		await write_message(message)
# 		await delay(10)

# 	message_label.visible = false

# 	timer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_game_over():
	message_label.visible = false
