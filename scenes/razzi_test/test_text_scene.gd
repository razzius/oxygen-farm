extends Control

const SPEED = 0.1

func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)
	$Timer.set_wait_time(SPEED)
	write_messages()


func delay(repeats = 1):
	for _i in repeats:
		$Timer.start()
		await $Timer.timeout


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


func write_message(message):
	$Message.text = ""

	for char_ in message:
		if char_ == "\n":
			await delay(4)

		elif char_ != " ":
			await delay()

		$Message.text += char_


func write_messages():
	for message in MESSAGES:
		await write_message(message)
		await delay(10)

	$Message.visible = false

	$Timer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_game_over():
	$Message.visible = false
