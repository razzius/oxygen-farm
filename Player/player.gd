extends CharacterBody2D

class_name Player

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var JETPACK_MAX_VELOCITY: float = -400.0
@export var JETPACK_ACCELERATION: float = 50.0

var JetPackVelocity: float = 0.0

@export var bJetpackEnabled: bool = false
var bJetPackActive: bool = false

@onready var JetStream: GPUParticles2D = $JetStream
var JetStreamSpawnX: float = 0.0

@onready var DirtTrail: GPUParticles2D = $DirtTrail
var DirtTrailSpawnX: float = 0.0

@onready var PlayerAnimatedSprite2D := $PlayerAnimatedSprite2D
@onready var ArmsAnimatedSprite2D := $ArmsAnimatedSprite2D
@onready var LeftCutCollisionDetection := $LeftCutArea/LeftCutCollisionDetection
@onready var RightCutCollisionDetection := $RightCutArea/RightCutCollisionDetection

var CutStartTime: float = 0.0
var CutEndTime: float = 0.0
@export var CutDuration: float = 0.2
var bWasCutting: bool = false

var bFacingRight: bool = true
var isPlayerRunning: bool = false
var wasPlayerRunning: bool = false
var cutAnimationPlaying: bool = false

func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)

	LeftCutCollisionDetection.disabled = true
	RightCutCollisionDetection.disabled = true

	JetStream.emitting = false
	JetStreamSpawnX = JetStream.position.x

	DirtTrail.emitting = false
	DirtTrailSpawnX = DirtTrail.position.x

	ArmsAnimatedSprite2D.animation_finished.connect(EndCuttingAnimation)


func _process(_delta: float) -> void:
	var bIsCutting: bool = IsCutting()

	if IsActivelyCutting():
		EnableCutCollision()

	if !bIsCutting and bWasCutting:
		StopCutting()

	if Input.is_action_just_pressed("cut"):
		StartCutting()

	isPlayerRunning = velocity.x != 0.0 and is_on_floor()

	if (!wasPlayerRunning and isPlayerRunning) or (wasPlayerRunning and !isPlayerRunning):
		SignalManager.on_running_usage_changed.emit(isPlayerRunning)


	DirtTrail.emitting = isPlayerRunning

	if isPlayerRunning:
		PlayerAnimatedSprite2D.play("run")
		if !cutAnimationPlaying:
			ArmsAnimatedSprite2D.play("run")
	elif bJetPackActive:
		PlayerAnimatedSprite2D.play("fly")
		if !cutAnimationPlaying:
			ArmsAnimatedSprite2D.play("fly")
	else:
		PlayerAnimatedSprite2D.play("idle")
		if !cutAnimationPlaying:
			ArmsAnimatedSprite2D.play("idle")

	bWasCutting = bIsCutting
	wasPlayerRunning = isPlayerRunning


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if bJetpackEnabled:
		if Input.is_action_pressed("up"):
			# if GameStateManager.OxygenLevel > 50.0:
			StartJetpack()
		else:
			StopJetpack()

		# if GameStateManager.OxygenLevel < 1.0 and bJetPackActive:
		# 	StopJetpack()


	if bJetPackActive:
		JetPackVelocity -= JETPACK_ACCELERATION

	if JetPackVelocity != 0.0:
		JetPackVelocity = maxf(JetPackVelocity, JETPACK_MAX_VELOCITY)
		velocity.y = JetPackVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		var jetpack_bonus = 1 + int(bJetPackActive)
		velocity.x = direction * SPEED * jetpack_bonus
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if !IsCutting():
		if bFacingRight and velocity.x < 0.0:
			bFacingRight = false
			PlayerAnimatedSprite2D.flip_h = true
			ArmsAnimatedSprite2D.flip_h = true
			JetStream.position.x = -JetStreamSpawnX
		elif !bFacingRight and velocity.x > 0.0:
			bFacingRight = true
			PlayerAnimatedSprite2D.flip_h = false
			ArmsAnimatedSprite2D.flip_h = false
			JetStream.position.x = JetStreamSpawnX

	move_and_slide()


func StartCutting() -> void:
	if IsCutting():
		return

	CutStartTime = GameStateManager.Now + CutDuration
	CutEndTime = GameStateManager.Now + (2 * CutDuration)
	# Todo: Play cutting sound effect here.
	ArmsAnimatedSprite2D.stop()
	ArmsAnimatedSprite2D.play("clip")

	$SnipSFX.play()

	cutAnimationPlaying = true

func EnableCutCollision() -> void:
	SetCutCollisionEnabled(true)

func StopCutting() -> void:
	SetCutCollisionEnabled(false)

func EndCuttingAnimation() -> void:
	cutAnimationPlaying = false
	if isPlayerRunning:
		ArmsAnimatedSprite2D.play("run")
	elif bJetPackActive:
		ArmsAnimatedSprite2D.play("fly")
	else:
		ArmsAnimatedSprite2D.play("idle")


func SetCutCollisionEnabled(bEnabled: bool) -> void:
	if bFacingRight:
		RightCutCollisionDetection.disabled = !bEnabled
	else:
		LeftCutCollisionDetection.disabled = !bEnabled


func IsCutting() -> bool:
	return GameStateManager.Now < CutEndTime

func IsActivelyCutting() -> bool:
	return GameStateManager.Now > CutStartTime and GameStateManager.Now < CutEndTime


func _on_right_cut_area_area_entered(area: Area2D) -> void:
	if area is PlantNode:
		CutPlantNode(area as PlantNode)


func _on_left_cut_area_area_entered(area: Area2D) -> void:
	if area is PlantNode:
		CutPlantNode(area as PlantNode)


func CutPlantNode(ThisPlantNode: PlantNode):
	SignalManager.on_plant_node_cut.emit(ThisPlantNode)


func StartJetpack():
	if !bJetPackActive:
		JetStream.emitting = true

	bJetPackActive = true

	$ThrustSFX.playing = true

	SignalManager.on_jetpack_usage_changed.emit(bJetPackActive)


func StopJetpack():
	if bJetPackActive:
		JetStream.emitting = false

	bJetPackActive = false
	JetPackVelocity = 0.0

	$ThrustSFX.playing = false

	SignalManager.on_jetpack_usage_changed.emit(bJetPackActive)

func on_game_over(onGameOver: String):
	set_process_mode(Node.PROCESS_MODE_DISABLED)
	set_process(false)
