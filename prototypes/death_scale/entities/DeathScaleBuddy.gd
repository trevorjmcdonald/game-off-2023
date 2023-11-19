extends CharacterBody3D
class_name DeathScaleBuddy

@export var blast_scene: PackedScene

@onready var animation_tree := $AnimationTree

var _movement := Vector3.ZERO
var _start_jump := false
var _is_blasting := false
var _blast_timer := 0.0
var _moving_last_frame := false

func move(movement: Vector3) -> void:
	_movement = movement

func start_jump() -> void:
	if is_on_floor() and not _start_jump:
		_start_jump = true

func stop_jump() -> void:
	_start_jump = false

func start_ability_1() -> void:
	if _blast_timer <= 0.0:
		_is_blasting = true

func stop_ability_1() -> void:
	_is_blasting = false

func start_ability_2() -> void:
	if _blast_timer <= 0.0:
		_is_blasting = true

func stop_ability_2() -> void:
	_is_blasting = false

func start_ability_3() -> void:
	if _blast_timer <= 0.0:
		_is_blasting = true

func stop_ability_3() -> void:
	_is_blasting = false

func _physics_process(delta: float) -> void:
	velocity.x = _movement.x * 5
	if is_on_floor() and _start_jump:
		velocity.y = Vector3.UP.y * 10
		_start_jump = false
		animation_tree["parameters/conditions/is_jumping"] = true
		animation_tree["parameters/conditions/is_grounded"] = false
	elif is_on_floor() and not _start_jump:
		animation_tree["parameters/conditions/is_jumping"] = false
		animation_tree["parameters/conditions/is_grounded"] = true
	velocity += Vector3.DOWN * 20 * delta
	move_and_slide()

	if is_on_floor():
		var moving := not is_zero_approx(velocity.x)

		if not _moving_last_frame and moving:
			animation_tree["parameters/conditions/is_moving"] = true
			animation_tree["parameters/conditions/is_idle"] = false
		elif _moving_last_frame and not moving:
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_idle"] = true

		_moving_last_frame = moving

	if _is_blasting:
		_is_blasting = false
		_blast_timer = 1.0
		var new_blast: Node3D = blast_scene.instantiate()
		get_tree().root.add_child(new_blast)
		new_blast.global_position = global_position
	else:
		_blast_timer = maxf(_blast_timer - delta, 0)

	match signf(_movement.x):
		1.0:
			rotation.y = 0
		-1.0:
			rotation.y = deg_to_rad(180)
