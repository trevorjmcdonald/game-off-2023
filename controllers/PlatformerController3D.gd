extends CharacterBody3D
class_name PlatformerController3D


signal jumped()
signal falling()
signal landed()
signal crouched()
signal stood()


@export var ground_speed: float = 12
@export var run_speed_modifier: float = 1.75
@export var jump_height: float = 4
@export var time_to_jump_apex: float = 0.4
@export var acceleration_time_in_air: float = 0.25
@export var acceleration_time_walking: float = 0.1
@export var acceleration_time_running: float = 0.2
@export var jump_buffer_time: float = 0.1
@export var coyote_time: float = 0.1
@export var stop_jump_rate: float = 0.5


var _paused := false
var _time_scale := 1.

var _movement := Vector3.ZERO
var _gravity: float = 0
var _jump_velocity: float = 0
var _velocity_x_smoothing: float = 0
var _jump_sent_at: float = -1
var _left_ground_at: float = 0
var _grounded_last_frame := false
var _stop_jump := false
var _is_running := false
var _is_jumping := false
var _crouch_sent_at: float = -1
var _is_crouching := false


func pause() -> void:
	_paused = true

func unpause() -> void:
	_paused = false

func is_paused() -> bool:
	return _paused

func set_timescale(time_scale: float) -> void:
	_time_scale = time_scale

func reset_timescale() -> void:
	set_timescale(1.)

func get_timescale() -> float:
	return _time_scale

func move(movement: Vector3) -> void:
	_movement = movement

func start_crouch() -> void:
	_crouch_sent_at = Time.get_ticks_msec()

func stop_crouch() -> void:
	_crouch_sent_at = -1.

func start_jump() -> void:
	_jump_sent_at = Time.get_ticks_msec()

func stop_jump() -> void:
	_stop_jump = true
	_jump_sent_at = -1

func start_running() -> void:
	_is_running = true

func stop_running() -> void:
	_is_running = false


func _calculate_jump_params() -> void:
	_gravity = -(2 * jump_height) / pow(time_to_jump_apex, 2)
	_jump_velocity = abs(_gravity) * time_to_jump_apex

func _handle_crouch() -> void:
	if _is_jumping:
		pass

	var current_time := Time.get_ticks_msec()
	var grounded := is_on_floor()

	if not grounded:
		return

	var crouch_valid_until := _crouch_sent_at + jump_buffer_time * 1000
	var should_crouch: bool = crouch_valid_until > current_time

	if should_crouch and not _is_crouching:
		_is_crouching = true
		emit_signal("crouched")
	elif _is_crouching and _crouch_sent_at < 0.:
		_is_crouching = false
		emit_signal("stood")

func _handle_jump() -> void:
	if _is_crouching:
		return

	var current_time := Time.get_ticks_msec()
	var grounded := is_on_floor()

	if not _grounded_last_frame and grounded:
		velocity.y = 0
		emit_signal("landed")

	var jump_valid_until := _jump_sent_at + jump_buffer_time * 1000
	var should_jump: bool = jump_valid_until > current_time

	var coyote_time_end := _left_ground_at + coyote_time * 1000
	var can_jump: bool = grounded or coyote_time_end > current_time
	can_jump = can_jump and not _is_jumping

	if should_jump and can_jump:
		_jump_sent_at = -1
		velocity.y += _jump_velocity
		_is_jumping = true
		emit_signal("jumped")
	elif _stop_jump:
		_stop_jump = false
		if velocity.y > 0:
			velocity.y *= stop_jump_rate

	if _grounded_last_frame and not grounded:
		_left_ground_at = current_time

	if _is_jumping and velocity.y <= 0:
		_is_jumping = false
		emit_signal("falling")

	_grounded_last_frame = grounded

func _handle_movement(delta: float) -> void:
	var run_modifier: float = 1
	if _is_running:
		run_modifier = run_speed_modifier
	var target_velocity_x := 0.

	if not _is_crouching:
		target_velocity_x = _movement.x * ground_speed * run_modifier

	var smooth_time = acceleration_time_walking
	if _is_running:
		smooth_time = acceleration_time_running
	if _is_jumping:
		smooth_time = acceleration_time_in_air
	var smooth_damp := MathUtils.smooth_damp(
		velocity.x,
		target_velocity_x,
		_velocity_x_smoothing,
		smooth_time,
		delta)
	velocity.x = smooth_damp.output
	_velocity_x_smoothing = smooth_damp.velocity


# https://en.wikipedia.org/wiki/Verlet_integration#Velocity_Verlet
func _calculate_translation(delta: float) -> Vector3:
	var acceleration := Vector3(0, _gravity, 0)
	var translation := velocity * delta + acceleration * pow(delta, 2) / 2
	velocity += acceleration * delta
	return translation


func _ready() -> void:
	_calculate_jump_params()

func _physics_process(delta: float) -> void:
	if _paused:
		return

	delta *= _time_scale

	_handle_crouch()
	_handle_jump()
	_handle_movement(delta)

	_calculate_translation(delta)
	move_and_slide()
