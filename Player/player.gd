extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var LeftCutCollisionDetection := $LeftCutCollisionDetection
@onready var RightCutCollisionDetection := $RightCutCollisionDetection

var CutEndTime : float = 0.0
@export var CutAnimationDuration : float = 0.25
var bWasCutting : bool = false

var bFacingRight : bool = true

func _ready() -> void:
	LeftCutCollisionDetection.disabled = true
	RightCutCollisionDetection.disabled = true


func _process(delta : float) -> void:
	var bIsCutting : bool = IsCutting()

	if !bIsCutting and bWasCutting:
		StopCutting()

	if Input.is_action_just_pressed("cut"):
		StartCutting()
	
	bWasCutting = bIsCutting


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if !IsCutting():
		if bFacingRight and velocity.x < 0.0:
			bFacingRight = false
		elif !bFacingRight and velocity.x > 0.0:
			bFacingRight = true

	move_and_slide()


func StartCutting() -> void:
	if IsCutting():
		return

	CutEndTime = GameStateManager.Now + CutAnimationDuration

	SetCutCollisionEnabled(true)


func StopCutting() -> void:
	SetCutCollisionEnabled(false)


func SetCutCollisionEnabled(bEnabled : bool) -> void:
	if bFacingRight:
		RightCutCollisionDetection.disabled = !bEnabled
	else:
		LeftCutCollisionDetection.disabled = !bEnabled
	

func IsCutting() -> bool:
	return GameStateManager.Now < CutEndTime