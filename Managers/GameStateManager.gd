extends Node

var Now: float = 0.0

# OXYGEN_MAX and OxygenLevel are in the thousands,
# but our quota is in the tens. Is this intentional?
const OXYGEN_MAX: float = 1000.0

var OxygenLevel: float = OXYGEN_MAX * 0.1 # start at 10%
var OxygenDeltaPerPlant: float = 0.01
var OxygenVelocity: float = 0.0
var NodeScale: Vector2

var PlayerIsRunning: bool = false
var JetPackIsActive: bool = false

var OxygenConsumptionRateFromRunning: float = 0.25
var OxygenConsumptionRateFromJetPack: float = 1.0

const QuotaGenMin: int = 40
const QuotaGenMax: int = 80
const QuotaAcceptableRange: int = 20
const InitialQuota: int = 30

var CurrentQuotaRange = Vector2(InitialQuota, InitialQuota + QuotaAcceptableRange)
var Quota: int = 0

var ShouldCreatePlantParticles: bool = true

var rng: RandomNumberGenerator

var PickupsToWin: int = 10


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

	OxygenLevel += OxygenVelocity
	
	OxygenLevel = minf(OxygenLevel, OXYGEN_MAX)
	OxygenLevel = maxf(OxygenLevel, 0.0)

	#if PlayerIsRunning:
		#OxygenLevel -= OxygenConsumptionRateFromRunning
	
	if JetPackIsActive:
		OxygenLevel -= OxygenConsumptionRateFromJetPack

	if OxygenLevel == OXYGEN_MAX:
		ShouldCreatePlantParticles = false
		SignalManager.on_full_oxygen.emit()


func OnPlantGrow() -> void:
	OxygenVelocity += OxygenDeltaPerPlant

func OnPlantNodeRemoved(_position: Vector2) -> void:
	OxygenVelocity -= OxygenDeltaPerPlant


func GetOxygenPercent() -> float:
	return OxygenLevel / OXYGEN_MAX


func OnJetpackUsageChanged(is_using: bool) -> void:
	JetPackIsActive = is_using


func OnRunningUsageChanged(is_running: bool) -> void:
	PlayerIsRunning = is_running


func CalculateQuota(iteration) -> void:
	print("iteration ", iteration)
	if iteration == PickupsToWin:
		SignalManager.on_game_over.emit("You won!")
		return

	if iteration <= 1:
		Quota = InitialQuota
	else:
		Quota = rng.randi_range(QuotaGenMin, QuotaGenMax)
		CurrentQuotaRange = Vector2(Quota, Quota + QuotaAcceptableRange)
	SignalManager.on_quota_changed.emit(Quota)
	SignalManager.on_show_message.emit("Incoming Quota:\nNew target %d%% - %d%% oxygen" % [Quota, Quota + QuotaAcceptableRange])


func OnBubblePopped() -> void:
	ShouldCreatePlantParticles = false
	SignalManager.on_game_over.emit("The bubble popped!")

func GatherOxygen() -> void:
	var adjusted_o2 = OxygenLevel / 10
	var is_acceptable = adjusted_o2 <= CurrentQuotaRange.y && adjusted_o2 >= CurrentQuotaRange.x
	if is_acceptable:
		OxygenLevel -= Quota * 10
		SignalManager.on_gather.emit()
	else:
		SignalManager.on_game_over.emit("You didn't meet your quota!")