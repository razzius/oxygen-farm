extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bEscapeIsPressed : bool = false
	var bShiftIsPressed : bool = false
	
	if Input.is_action_pressed("escape"):
		bEscapeIsPressed = true
	
	if Input.is_action_pressed("shift"):
		bShiftIsPressed = true
	
	if bEscapeIsPressed and bShiftIsPressed:
		get_tree().quit()
