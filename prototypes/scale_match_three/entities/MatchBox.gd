extends AnimatableBody3D
class_name MatchBox

##### Signals
signal found_matches(matches: Array[MatchBox])


##### Exports
@export var move_rate: float = 6.0
@export var fall_rate: float = 2.0
@export var max_match_distance: float = 10.0
@export var min_matches := 3
@export var weight := 1.0


##### OnReady


##### Variables
var _paused := false
var _matchbox_type: MatchBoxType
var _target_x := 0.0
var _force_move := false
var _force_move_to := Vector3.ZERO
var _grounded := false


##### Public Methods
func pause() -> void:
	_paused = true

func unpause() -> void:
	_paused = false

func is_paused() -> bool:
	return _paused

func move_x(val: Vector3) -> void:
	if is_equal_approx(_target_x, global_position.x):
		_target_x += snappedf(val.x, 1)

func get_type() -> MatchBoxType:
	return _matchbox_type

func is_match(other: MatchBox) -> bool:
	return _grounded and _matchbox_type.is_match(other.get_type())

func set_type(type: MatchBoxType) -> void:
	var mesh_instance = $MeshInstance3D as MeshInstance3D
	mesh_instance.material_override = type.override_material
	_matchbox_type = type

func check_for_matches() -> void:
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
	return _grounded


##### Private Methods
func _get_matches(dir: Vector3) -> Array[MatchBox]:
	var space_state = get_world_3d().get_direct_space_state()
	var matches: Array[MatchBox] = []
	var exclude_rids: Array[RID] = []
	var check_against: MatchBox = self
	var checking := true
	while checking:
		var query = PhysicsRayQueryParameters3D.create(
			global_position,
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
	var check_matches := false
	if _force_move:
		var target_x_diff = _force_move_to.x - global_position.x
		global_position = _force_move_to
		_force_move = false
		_target_x += target_x_diff

	if not is_equal_approx(_target_x, global_position.x):
		var move := Vector3(_target_x - global_position.x, 0, 0).normalized()
		if move_rate * delta < abs(_target_x - global_position.x):
			move *= move_rate * delta
		else:
			move *= _target_x - global_position.x
		var collision = move_and_collide(move)
		if collision:
			var collider = collision.get_collider()
			if collider is MatchBox:
				global_position.x = snappedf(global_position.x, 0.5)
				_target_x = global_position.x
				check_matches = true
		elif abs(_target_x - global_position.x) < 0.1:
			global_position.x = _target_x

	var collision = move_and_collide(Vector3.DOWN * fall_rate * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is MatchBox or collider is MatchFloor:
			global_position.y = snappedf(global_position.y, 0.5)
			if not _grounded:
				_grounded = true
				check_matches = true
		elif collider is MatchBuddy:
			if collider.global_position.y <= global_position.y - 0.5:
				collider.crush()
				_grounded = false
	else:
		_grounded = false

	if check_matches:
		check_for_matches()

##### Overrides
func _physics_process(delta: float) -> void:
	if _paused:
		return
	_move(delta)


##### Event Handlers

