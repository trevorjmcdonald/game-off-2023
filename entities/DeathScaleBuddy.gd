extends PlatformerController3D
class_name DeathScaleBuddy

signal consumed()
signal entered_spirit_form()
signal exited_spirit_form()

@export var spawn_point: Node3D

@export var ability_1: BuddyAbility
@export var ability_2: BuddyAbility
@export var ability_3: BuddyAbility

var in_spirit_form := false

func pause() -> void:
	_paused = true
	_lock()

func unpause() -> void:
	_paused = false
	if not in_spirit_form:
		_unlock()

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
	in_spirit_form = true
	entered_spirit_form.emit()
	_lock()

	var tween = create_tween()
	tween.tween_property(self, "global_position", spawn_point.global_position, 1.)
	tween.tween_callback(_reached_spawn)

func be_consumed(ammit: Ammit) -> void:
	in_spirit_form = true
	entered_spirit_form.emit()
	_lock()

	var tween = create_tween()
	tween.tween_property(self, "global_position", ammit.above_waypoint.global_position, 3.)
	tween.tween_callback(_prepared.bind(ammit))

func _ready() -> void:
	_calculate_jump_params() # since we can't call the base _ready

func _process(_delta: float) -> void:
	if _paused:
		return

	if in_spirit_form:
		return

	_set_facing()

func _set_facing() -> void:
	match signf(_movement.x):
		1.0:
			rotation.y = 0
		-1.0:
			rotation.y = deg_to_rad(180)

func _lock() -> void:
	if ability_1:
		ability_1.pause()
	if ability_2:
		ability_2.pause()
	if ability_3:
		ability_3.pause()

func _unlock() -> void:
	if ability_1:
		ability_1.unpause()
	if ability_2:
		ability_2.unpause()
	if ability_3:
		ability_3.unpause()

func _reached_spawn() -> void:
	in_spirit_form = false
	exited_spirit_form.emit()
	if not _paused:
		_unlock()

func _prepared(ammit: Ammit) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", ammit.gullet_waypoint.global_position, 2.)
	tween.tween_callback(_consumed)

func _consumed() -> void:
	emit_signal("consumed")
	queue_free()
