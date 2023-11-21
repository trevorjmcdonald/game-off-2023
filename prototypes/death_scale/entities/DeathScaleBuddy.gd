extends PlatformerController3D
class_name DeathScaleBuddy

signal consumed()

@export var spawn_point: Node3D

@export var ability_1: BuddyAbility
@export var ability_2: BuddyAbility
@export var ability_3: BuddyAbility

@onready var animation_tree := $AnimationTree

var _in_spirit_form := false

func pause() -> void:
	_paused = true
	if ability_1:
		ability_1.pause()
	if ability_2:
		ability_2.pause()
	if ability_3:
		ability_3.pause()

func unpause() -> void:
	_paused = false
	if ability_1:
		ability_1.unpause()
	if ability_2:
		ability_2.unpause()
	if ability_3:
		ability_3.unpause()

func start_ability_1() -> void:
	if ability_1:
		ability_1.start_ability()

func stop_ability_1() -> void:
	if ability_1:
		ability_1.stop_ability()

func start_ability_2() -> void:
	if ability_2:
		ability_2.start_ability()

func stop_ability_2() -> void:
	if ability_2:
		ability_2.stop_ability()

func start_ability_3() -> void:
	if ability_3:
		ability_3.start_ability()

func stop_ability_3() -> void:
	if ability_3:
		ability_3.stop_ability()

func return_to_spawn() -> void:
	_in_spirit_form = true
	pause()
	animation_tree["parameters/conditions/is_moving"] = false
	animation_tree["parameters/conditions/is_idle"] = true
	animation_tree["parameters/conditions/is_crouched"] = false
	animation_tree["parameters/conditions/is_standing"] = false
	animation_tree["parameters/conditions/is_jumping"] = false
	animation_tree["parameters/conditions/is_grounded"] = true
	animation_tree["parameters/conditions/in_spirit_form"] = true
	animation_tree["parameters/conditions/in_mortal_form"] = false

	var tween = create_tween()
	tween.tween_property(self, "global_position", spawn_point.global_position, 1.)
	tween.tween_callback(_reached_spawn)

func be_consumed(ammit: Ammit) -> void:
	_in_spirit_form = true
	pause()
	animation_tree["parameters/conditions/is_moving"] = false
	animation_tree["parameters/conditions/is_idle"] = true
	animation_tree["parameters/conditions/is_crouched"] = false
	animation_tree["parameters/conditions/is_standing"] = false
	animation_tree["parameters/conditions/is_jumping"] = false
	animation_tree["parameters/conditions/is_grounded"] = true
	animation_tree["parameters/conditions/in_spirit_form"] = true
	animation_tree["parameters/conditions/in_mortal_form"] = false

	var tween = create_tween()
	tween.tween_property(self, "global_position", ammit.above_waypoint.global_position, 3.)
	tween.tween_callback(_prepared.bind(ammit))

func _ready() -> void:
	_calculate_jump_params() # since we can't call the base _ready
	jumped.connect(_on_jumped)
	landed.connect(_on_landed)
	falling.connect(_on_falling)
	crouched.connect(_on_crouched)
	stood.connect(_on_stood)

func _process(_delta: float) -> void:
	if _paused:
		return

	if _in_spirit_form:
		return

	_set_facing()
	_update_animation_params()

func _set_facing() -> void:
	match signf(_movement.x):
		1.0:
			rotation.y = 0
		-1.0:
			rotation.y = deg_to_rad(180)

func _update_animation_params() -> void:
	var is_moving := not absf(velocity.x) < 0.1
	animation_tree["parameters/conditions/is_moving"] = is_moving
	animation_tree["parameters/conditions/is_idle"] = not is_moving
	animation_tree["parameters/conditions/in_spirit_form"] = _in_spirit_form
	animation_tree["parameters/conditions/in_mortal_form"] = not _in_spirit_form

func _on_jumped() -> void:
	animation_tree["parameters/conditions/is_jumping"] = true
	animation_tree["parameters/conditions/is_grounded"] = false

func _on_landed() -> void:
	animation_tree["parameters/conditions/is_jumping"] = false
	animation_tree["parameters/conditions/is_grounded"] = true

func _on_falling() -> void:
	# some kind of falling animation maybe?
	pass

func _on_crouched() -> void:
	animation_tree["parameters/conditions/is_crouched"] = true
	animation_tree["parameters/conditions/is_standing"] = false
	animation_tree["parameters/conditions/is_jumping"] = false
	animation_tree["parameters/conditions/is_grounded"] = true

func _on_stood() -> void:
	animation_tree["parameters/conditions/is_crouched"] = false
	animation_tree["parameters/conditions/is_standing"] = true

func _reached_spawn() -> void:
	_in_spirit_form = false
	unpause()

func _prepared(ammit: Ammit) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", ammit.gullet_waypoint.global_position, 2.)
	tween.tween_callback(_consumed)

func _consumed() -> void:
	emit_signal("consumed")
	queue_free()
