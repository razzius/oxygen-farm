extends Node

var Now: float = 0.0

# OXYGEN_MAX and OxygenLevel are in the thousands,
# but our quota is in the tens. Is this intentional?
const OXYGEN_MAX: float = 1000.0
const OXYGEN_DELTA_PER_PLANT: float = 0.5
const QUOTA_GEN_MIN: int = 40
const QUOTA_GEN_MAX: int = 80
const QUOTA_ACCEPTABLE_RANGE: int = 20
const INITIAL_QUOTA: int = 30

var NodeScale: Vector2
var OxygenConsumptionRateFromRunning: float = 0.25
var OxygenConsumptionRateFromJetPack: float = 1.0
var ShouldCreatePlantParticles: bool = true
var PickupsToWin: int = 10
var rng: RandomNumberGenerator

# These values need to be reinitialized when the game is reset
var OxygenLevel: float
var OxygenVelocity: float
var PlayerIsRunning: bool
var JetPackIsActive: bool
var CurrentQuotaRange
var Quota: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()

	SignalManager.on_plant_grow.connect(OnPlantGrow)
	SignalManager.on_plant_node_removed.connect(OnPlantNodeRemoved)
	SignalManager.on_jetpack_usage_changed.connect(OnJetpackUsageChanged)
	SignalManager.on_running_usage_changed.connect(OnRunningUsageChanged)
	SignalManager.on_bubble_popped.connect(OnBubblePopped)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Now += delta

	if !ShouldCreatePlantParticles:
		ShouldCreatePlantParticles = true

	OxygenLevel += OxygenVelocity * delta
	
	OxygenLevel = minf(OxygenLevel, OXYGEN_MAX)
	OxygenLevel = maxf(OxygenLevel, 0.0)

	#if PlayerIsRunning:
		#OxygenLevel -= OxygenConsumptionRateFromRunning * delta
	
	if JetPackIsActive:
		OxygenLevel -= OxygenConsumptionRateFromJetPack * delta

	if OxygenLevel == OXYGEN_MAX:
		ShouldCreatePlantParticles = false
		SignalManager.on_full_oxygen.emit()


func OnPlantGrow() -> void:
	OxygenVelocity += OXYGEN_DELTA_PER_PLANT

func OnPlantNodeRemoved(_position: Vector2) -> void:
	OxygenVelocity -= OXYGEN_DELTA_PER_PLANT


func GetOxygenPercent() -> float:
	return OxygenLevel / OXYGEN_MAX


func OnJetpackUsageChanged(is_using: bool) -> void:
	JetPackIsActive = is_using


func OnRunningUsageChanged(is_running: bool) -> void:
	PlayerIsRunning = is_running


func GetCurrentIsAcceptable() -> bool:
	var adjusted_o2 = OxygenLevel / 10
	var is_acceptable = adjusted_o2 >= CurrentQuotaRange.x && adjusted_o2 <= CurrentQuotaRange.y
	return is_acceptable

func CalculateQuota(iteration) -> void:
	if iteration == PickupsToWin:
		SignalManager.on_game_over.emit("You won!")
		return

	if iteration <= 1:
		Quota = INITIAL_QUOTA
	else:
		Quota = rng.randi_range(QUOTA_GEN_MIN, QUOTA_GEN_MAX)

	CurrentQuotaRange = Vector2(Quota, Quota + QUOTA_ACCEPTABLE_RANGE)
	SignalManager.on_quota_changed.emit(Quota)
	SignalManager.on_show_message.emit("Incoming Quota:\nNew target %d%% - %d%% oxygen" % [Quota, Quota + QUOTA_ACCEPTABLE_RANGE])


func OnBubblePopped() -> void:
	ShouldCreatePlantParticles = false
	SignalManager.on_game_over.emit("The bubble popped!")

func GatherOxygen() -> void:
	if GetCurrentIsAcceptable():
		OxygenLevel -= Quota * 10
		SignalManager.on_gather.emit()
	else:
		SignalManager.on_game_over.emit("You didn't meet your quota!")

func InitializeGame() -> void:
	OxygenLevel = OXYGEN_MAX * 0.1
	OxygenVelocity = 0.0
	PlayerIsRunning = false
	JetPackIsActive = false
	CurrentQuotaRange = Vector2(INITIAL_QUOTA, INITIAL_QUOTA + QUOTA_ACCEPTABLE_RANGE)
	Quota = 0