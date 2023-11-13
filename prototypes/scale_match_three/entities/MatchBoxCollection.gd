extends Node3D

@export var spawner: Spawner
@export var min_x := -4
@export var max_x := 3

@export var weight_manager: WeightManager

@export var matchbox_types: Array[MatchBoxType] = []

var _matchbox_type_table := WeightedTable.new()
var _last_weight_total := 0.0

func _ready() -> void:
	for item in matchbox_types:
		_matchbox_type_table.add_item(item, item.weight)

	spawner.object_spawned.connect(_on_spawner_object_spawned)

func _on_spawner_object_spawned(object: Node) -> void:
	if object is MatchBox:
		var matchbox_type = _matchbox_type_table.get_item()
		object.set_type(matchbox_type)
		object.move_to(Vector3(global_position.x + randi_range(min_x, max_x) + 0.5, global_position.y, global_position.z))
		object.found_matches.connect(_on_matchbox_found_matches)
		object.unpause()

func _on_matchbox_found_matches(matches: Array[MatchBox]) -> void:
	for matchbox in matches:
		remove_child(matchbox)
		matchbox.queue_free()

func _process(_delta: float) -> void:
	var weight_total := 0.0
	for child in get_children():
		if child is MatchBox:
			if child.is_grounded():
				weight_total += child.weight

	if not is_equal_approx(weight_total, _last_weight_total):
		if weight_manager:
			if weight_total > _last_weight_total:
				weight_manager.add_weight(weight_total - _last_weight_total)
			else:
				weight_manager.remove_weight(_last_weight_total - weight_total)
		_last_weight_total = weight_total
