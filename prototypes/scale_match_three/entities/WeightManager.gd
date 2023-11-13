extends Node3D
class_name WeightManager

@export var weight_mod := 0.1
@export var drop_rate := 0.1

var _current_weight := 0.0

func add_weight(weight: float) -> void:
	_current_weight += weight

func remove_weight(weight: float) -> void:
	_current_weight = maxf(_current_weight - weight, 0.0)

func _physics_process(delta: float) -> void:
	position.y = lerpf(position.y, _current_weight * weight_mod, delta * drop_rate)
