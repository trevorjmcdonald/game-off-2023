extends Node
class_name ScaleManager

@export var scale_arm: Node3D
@export var left_chain_connector: Node3D
@export var right_chain_connector: Node3D
@export var left_balance: Balance
@export var right_balance: Balance
@export var chain_mat: Material

@export var kg_to_y := 0.1
@export var move_rate := 0.1

@onready var _left_balance_origin := left_balance.position
@onready var _right_balance_origin := right_balance.position
@onready var _bar_length: float = abs(left_balance.position.x - right_balance.position.x)
@onready var _arm_length: float = _bar_length / 2.0

var _paused := false

func pause() -> void:
	_paused = true

func unpause() -> void:
	_paused = false

func _ready() -> void:
	_build_chain(
		left_balance,
		left_chain_connector,
		left_balance.get_left_chain_connector()
	)
	_build_chain(
		left_balance,
		left_chain_connector,
		left_balance.get_right_chain_connector()
	)
	_build_chain(
		right_balance,
		right_chain_connector,
		right_balance.get_left_chain_connector()
	)
	_build_chain(
		right_balance,
		right_chain_connector,
		right_balance.get_right_chain_connector()
	)

func _build_chain(balance: Balance, arm_connector: Node3D, balance_connector: Node3D) -> void:
	var chain := MeshInstance3D.new()
	balance.add_child(chain)
	var mesh := CylinderMesh.new()
	mesh.surface_set_material(0, chain_mat)
	mesh.top_radius = 0.05
	mesh.bottom_radius = 0.05
	var diff := arm_connector.global_position - \
		balance_connector.global_position
	mesh.height = diff.length()
	chain.mesh = mesh
	chain.global_position = balance_connector.global_position + diff.normalized() * diff.length() / 2.0
	chain.global_rotation_degrees.z = -signf(diff.x) * rad_to_deg(acos(diff.y / mesh.height))

func _physics_process(delta: float) -> void:
	if _paused:
		return
	_adjust_weights(delta)
	_adjust_arm()

func _adjust_weights(delta: float) -> void:
	var left_mass := left_balance.calculate_total_mass()
	var right_mass := right_balance.calculate_total_mass()
	var balance := (right_mass - left_mass) / 2.0
	var delta_y := balance * kg_to_y
	var delta_x := 0.0
	if not is_zero_approx(delta_y):
		delta_x = _arm_length - sqrt(pow(_arm_length, 2) - pow(delta_y, 2))

	var left_x := _left_balance_origin.x + delta_x
	var left_y := _left_balance_origin.y + delta_y

	var right_x := _right_balance_origin.x - delta_x
	var right_y := _right_balance_origin.y - delta_y

	left_balance.position = Vector3(
		lerpf(left_balance.position.x, left_x, delta * move_rate),
		lerpf(left_balance.position.y, left_y, delta * move_rate),
		left_balance.position.z)

	right_balance.position = Vector3(
		lerpf(right_balance.position.x, right_x, delta * move_rate),
		lerpf(right_balance.position.y, right_y, delta * move_rate),
		right_balance.position.z)

func _adjust_arm() -> void:
	var adjacent := _bar_length / 2.0
	var opposite := right_balance.position.y - _right_balance_origin.y

	var angle = atan2(opposite, adjacent)
	scale_arm.rotation.z = angle
