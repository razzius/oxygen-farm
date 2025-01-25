extends CharacterBody2D


@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var JETPACK_MAX_VELOCITY: float = -400.0
@export var JETPACK_ACCELERATION: float = 50.0

var JetPackVelocity: float = 0.0

@export var bJetpackEnabled: bool = false
var bJetPackActive: bool = false

@onready var PlayerSprite := $PlayerSprite
@onready var CutAnimatedSprite := $CutAnimatedSprite
@onready var LeftCutCollisionDetection := $LeftCutArea/LeftCutCollisionDetection
@onready var RightCutCollisionDetection := $RightCutArea/RightCutCollisionDetection

var CutEndTime: float = 0.0
@export var CutAnimationDuration: float = 0.25
var bWasCutting: bool = false

var bFacingRight: bool = true

func _ready() -> void:
	LeftCutCollisionDetection.disabled = true
	RightCutCollisionDetection.disabled = true
	
	CutAnimatedSprite.visible = false


func _process(delta: float) -> void:
	var bIsCutting: bool = IsCutting()

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

	if bJetpackEnabled:
		if Input.is_action_pressed("up"):
			bJetPackActive = true
		else:
			bJetPackActive = false
			JetPackVelocity = 0.0
	
	if bJetPackActive:
		JetPackVelocity -= JETPACK_ACCELERATION
		
	if JetPackVelocity != 0.0:
		JetPackVelocity = maxf(JetPackVelocity, JETPACK_MAX_VELOCITY)
		velocity.y = JetPackVelocity

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
			PlayerSprite.flip_h = true
			CutAnimatedSprite.flip_h = true
		elif !bFacingRight and velocity.x > 0.0:
			bFacingRight = true
			PlayerSprite.flip_h = false
			CutAnimatedSprite.flip_h = false

	move_and_slide()


func StartCutting() -> void:
	if IsCutting():
		return

	CutEndTime = GameStateManager.Now + CutAnimationDuration

	CutAnimatedSprite.visible = true
	CutAnimatedSprite.play("Cut")

	SetCutCollisionEnabled(true)


func StopCutting() -> void:
	CutAnimatedSprite.visible = false
	CutAnimatedSprite.stop()
	
	SetCutCollisionEnabled(false)


func SetCutCollisionEnabled(bEnabled: bool) -> void:
	if bFacingRight:
		RightCutCollisionDetection.disabled = !bEnabled
	else:
		LeftCutCollisionDetection.disabled = !bEnabled
	

func IsCutting() -> bool:
	return GameStateManager.Now < CutEndTime


func _on_right_cut_area_area_entered(area: Area2D) -> void:
	if area is PlantNode:
		CutPlantNode(area as PlantNode)


func _on_left_cut_area_area_entered(area: Area2D) -> void:
	if area is PlantNode:
		CutPlantNode(area as PlantNode)


func CutPlantNode(ThisPlantNode: PlantNode):
	SignalManager.on_plant_node_cut.emit(ThisPlantNode)
