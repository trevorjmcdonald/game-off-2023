extends AnimatableBody3D
class_name MatchBox

##### Signals
signal found_matches(matches: Array[MatchBox])


##### Exports
@export var move_rate: float = 6.0
@export var fall_rate: float = 2.0
@export var max_match_distance: float = 10.0
@export var min_matches := 3


##### OnReady


##### Variables
var _paused := false
var _matchbox_type: MatchBoxType
var _target_x := 0.0
var _force_move := false
var _force_move_to := Vector3.ZERO
var _sitting_on: WeakRef
var _sit_delta := Vector3.ZERO
var _check_for_matches := false


##### Public Methods
func pause() -> void:
	_paused = true

func unpause() -> void:
	_paused = false

func is_paused() -> bool:
	return _paused

func move_x(val: Vector3) -> void:
	_target_x += val.x

func move_left(dist: int = 1) -> void:
	_target_x -= dist

func move_right(dist: int = 1) -> void:
	_target_x += dist

func get_type() -> MatchBoxType:
	return _matchbox_type

func is_match(other: MatchBox) -> bool:
	if _sitting_on and _sitting_on.get_ref():
		return _matchbox_type.is_match(other.get_type())
	return false

func set_type(type: MatchBoxType) -> void:
	var mesh_instance = $MeshInstance3D as MeshInstance3D
	mesh_instance.material_override = type.override_material
	_matchbox_type = type

func check_for_matches() -> void:
	print("checking for matches")

	var matches_h: Array[MatchBox] = []
	var matches_v: Array[MatchBox] = []
	# Check for horizontal matches
	matches_h.append_array(_get_matches(Vector3.LEFT))
	matches_h.append_array(_get_matches(Vector3.RIGHT))
	# Check for vertical matches
	matches_v.append_array(_get_matches(Vector3.UP))
	matches_v.append_array(_get_matches(Vector3.DOWN))

	if matches_h.size() >= min_matches - 1 or matches_v.size() >= min_matches - 1:
		matches_h.append(self)
		emit_signal("found_matches", matches_h + matches_v)

func move_to(pos: Vector3) -> void:
	_force_move = true
	_force_move_to = pos

func is_grounded() -> bool:
	return _sitting_on and _sitting_on.get_ref()


##### Private Methods
func _get_matches(dir: Vector3) -> Array[MatchBox]:
	var space_state = get_world_3d().get_direct_space_state()
	var matches: Array[MatchBox] = []
	var exclude_rids: Array[RID] = []
	var check_against: MatchBox = self
	var checking := true
	while checking:
		var query = PhysicsRayQueryParameters3D.create(\
			global_position,\
			global_position + dir.normalized() * max_match_distance)
		query.exclude = exclude_rids

		var result = space_state.intersect_ray(query)
		if result and result.collider is MatchBox:
			var matchbox = result.collider as MatchBox
			if is_match(matchbox) and check_against.global_position.distance_to(matchbox.global_position) < 1.1:
				matches.append(matchbox)
				exclude_rids.append(matchbox.get_rid())
				check_against = matchbox
			else:
				checking = false
		else:
			checking = false

	return matches

func _move(delta: float) -> void:
	if _force_move:
		var target_x_diff = _force_move_to.x - global_position.x
		global_position = _force_move_to
		_force_move = false
		_target_x += target_x_diff
		return

	if _sitting_on and _sitting_on.get_ref():
		if global_position - _sitting_on.get_ref().global_position != _sit_delta:
			global_position = _sitting_on.get_ref().global_position + _sit_delta
		if _check_for_matches:
			_check_for_matches = false
			check_for_matches()
		return

	var final_movement := global_position
	var movement := Vector3.ZERO
	if _target_x < global_position.x:
		movement.x = max(-move_rate * delta, _target_x - global_position.x)
	elif _target_x > global_position.x:
		movement.x = min(move_rate * delta, _target_x - global_position.x)

	var collision = move_and_collide(movement, true)
	if collision:
		var collider = collision.get_collider()
		if collider is MatchBox:
			_target_x = global_position.x
		final_movement.x = collision.get_travel().x
	else:
		final_movement.x = movement.x

	movement.x = 0
	movement.y = -fall_rate * delta
	collision = move_and_collide(movement, true)
	if collision:
		var collider = collision.get_collider()
		if collider is MatchFloor or collider is MatchBox:
			_sitting_on = weakref(collider)
			_sit_delta = global_position - _sitting_on.get_ref().global_position
			_check_for_matches = true
		elif collider is MatchBuddy:
			collider.murder()
		final_movement.y = collision.get_travel().y
	else:
		_sitting_on = null
		final_movement.y = movement.y

	move_and_collide(final_movement)


##### Overrides
func _ready() -> void:
	#reached_target.connect(_on_reached_target)
	pass

func _physics_process(delta: float) -> void:
	if _paused:
		return
	_move(delta)


##### Event Handlers
#func _on_reached_target() -> void:
#	check_for_matches()

