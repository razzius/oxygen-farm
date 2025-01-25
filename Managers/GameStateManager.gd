extends Node

var Now : float = 0.0

var OxygenLevel : float = 0.0
var OxygenDeltaPerPlant : float = 0.01
var OxygenVelocity : float = 0.0
var OxygenQuota : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_plant_grow.connect(OnPlantGrow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Now += delta

	OxygenLevel += OxygenVelocity


func OnPlantGrow() -> void:
	OxygenVelocity += OxygenDeltaPerPlant
