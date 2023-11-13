extends Node
class_name ScaleManager

@export var scale_arm: Node3D
@export var left_balance: Balance
@export var right_balance: Balance

@export var kg_to_y := 0.1
@export var move_rate := 0.1

@onready var _left_balance_origin := left_balance.position
@onready var _right_balance_origin := right_balance.position
@onready var _bar_length: float = abs(left_balance.position.x - right_balance.position.x)

func _physics_process(delta: float) -> void:
	_adjust_weights(delta)
	_adjust_arm()

func _adjust_weights(delta: float) -> void:
	var left_mass := left_balance.calculate_total_mass()
	var right_mass := right_balance.calculate_total_mass()
	var balance := (right_mass - left_mass) / 2.0
	var left_y := _left_balance_origin.y + balance * kg_to_y
	var right_y := _right_balance_origin.y - balance * kg_to_y

	left_balance.position.y = lerpf(left_balance.position.y, left_y, delta * move_rate)
	right_balance.position.y = lerpf(right_balance.position.y, right_y, delta * move_rate)

func _adjust_arm() -> void:
	var adjacent := _bar_length / 2.0
	var opposite := right_balance.position.y - _right_balance_origin.y

	var angle = atan2(opposite, adjacent)
	scale_arm.rotation.z = angle
