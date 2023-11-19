extends CharacterBody3D
class_name PlatformerController


signal jumped()
signal landed()


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


var _movement := Vector3.ZERO
var _gravity: float = 0
var _jumpvelocity: float = 0
var velocity_x_smoothing: float = 0
var _jump_sent_at: float = -1
var _left_ground_at: float = 0
var _grounded_last_frame := false
var _stop_jump := false
var _is_running := false
var _is_jumping := false


func move(movement: Vector3) -> void:
	_movement = movement

func start_jump(current_time: float) -> void:
	_jump_sent_at = current_time

func stop_jump() -> void:
	_stop_jump = true
	_jump_sent_at = -1

func start_running() -> void:
	_is_running = true

func stop_running() -> void:
	_is_running = false


func _calculate_jump_params() -> void:
	_gravity = -(2 * jump_height) / pow(time_to_jump_apex, 2)
	_jumpvelocity = abs(_gravity) * time_to_jump_apex

func _handle_jump(current_time: float) -> void:
	var grounded := is_on_floor()
	var should_jump: bool = _jump_sent_at + jump_buffer_time > current_time
	var can_jump: bool = _left_ground_at + coyote_time > current_time
	can_jump = can_jump and not _is_jumping

	if should_jump and can_jump:
		_jump_sent_at = -1
		velocity.y += _jumpvelocity
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

	if not _grounded_last_frame and grounded:
		velocity.y = 0
		emit_signal("landed")

	_grounded_last_frame = grounded

func _handle_movement(delta: float) -> void:
	var run_modifier: float = 1
	if _is_running:
		run_modifier = run_speed_modifier
	var targetvelocity_x := _movement.x * ground_speed * run_modifier
	var smooth_time = acceleration_time_walking
	if _is_running:
		smooth_time = acceleration_time_running
	if _is_jumping:
		smooth_time = acceleration_time_in_air
	var smooth_damp := MathUtils.smooth_damp(
		velocity.x,
		targetvelocity_x,
		velocity_x_smoothing,
		smooth_time,
		delta)
	velocity.x = smooth_damp.output
	velocity_x_smoothing = smooth_damp.velocity


# https://en.wikipedia.org/wiki/Verlet_integration#Velocity_Verlet
func _calculate_translation(delta: float) -> Vector3:
	var acceleration := Vector3(0, _gravity, 0)
	var translation := velocity * delta + acceleration * pow(delta, 2) / 2
	velocity += acceleration * delta
	return translation


func _ready() -> void:
	_calculate_jump_params()

func _process(_delta: float) -> void:
	var movement := Vector3.ZERO
	if Input.is_action_pressed("move_left"):
		movement += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		movement += Vector3.RIGHT
	if Input.is_action_just_pressed("jump"):
		start_jump(Time.get_ticks_msec())
	elif Input.is_action_just_released("jump"):
		stop_jump()

	move(movement)

func _physics_process(delta: float) -> void:
	_handle_jump(Time.get_ticks_msec())
	_handle_movement(delta)

	#move_and_slide()

	var translation := _calculate_translation(delta)
	move_and_collide(translation)
