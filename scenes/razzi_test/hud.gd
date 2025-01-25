extends CanvasLayer

const SPEED = 0.1

func delay():
	$Timer.start()
	await $Timer.timeout

func on_timer_timeout():
	var letters = ""
	var message = """GOOD MORNING
	young oxygenfarmer..."""
	
	for i in message:
		print(i)
		print(i == '\n')
		if i == "\n":
			for _i in 4:
				await delay()

		elif i != " ":
			await delay()

		$Message.text += i
	
	$Timer.stop()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.set_wait_time(SPEED)
	on_timer_timeout()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
