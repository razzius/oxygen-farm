extends Node

var Now: float = 0.0

const OXYGEN_MAX: float = 1000.0

var OxygenLevel: float = OXYGEN_MAX / 2.0
var OxygenDeltaPerPlant: float = 0.01
var OxygenVelocity: float = 0.0
var NodeScale: Vector2

var PlayerIsRunning : bool = false
var JetPackIsActive : bool = false

var OxygenConsumptionRateFromRunning : float = 0.25
var OxygenConsumptionRateFromJetPack : float = 1.0

var QuotaMin: float = 20.0
var QuotaMax: float = 80.0
var Quota: float = 0.0

var rng : RandomNumberGenerator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()

	SignalManager.on_plant_grow.connect(OnPlantGrow)
	SignalManager.on_plant_node_removed.connect(OnPlantNodeRemoved)
	SignalManager.on_jetpack_usage_changed.connect(OnJetpackUsageChanged)
	SignalManager.on_running_usage_changed.connect(OnRunningUsageChanged)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Now += delta

	OxygenLevel += OxygenVelocity
	
	OxygenLevel = minf(OxygenLevel, OXYGEN_MAX)

	if PlayerIsRunning:
		OxygenLevel -= OxygenConsumptionRateFromRunning
	
	if JetPackIsActive:
		OxygenLevel -= OxygenConsumptionRateFromJetPack


func OnPlantGrow() -> void:
	OxygenVelocity += OxygenDeltaPerPlant

func OnPlantNodeRemoved(position : Vector2) -> void:
	OxygenVelocity -= OxygenDeltaPerPlant


func GetOxygenPercent() -> float:
	return OxygenLevel / OXYGEN_MAX


func OnJetpackUsageChanged(is_using : bool) -> void:
	JetPackIsActive = is_using


func OnRunningUsageChanged(is_running : bool) -> void:
	PlayerIsRunning = is_running


func CalculateQuota() -> void:
	Quota = rng.randf_range(QuotaMin, QuotaMax)
