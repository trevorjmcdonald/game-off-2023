extends Node3D

@export var spawner: Spawner
@export var min_x = -5
@export var max_x = 4

@export var matchbox_types: Array[MatchBoxType] = []

var _matchbox_type_table := WeightedTable.new()

func _ready() -> void:
	for item in matchbox_types:
		_matchbox_type_table.add_item(item, item.weight)

	spawner.connect("object_spawned", _on_spawner_object_spawned)

func _on_spawner_object_spawned(object: Node) -> void:
	if object is MatchBox:
		var matchbox_type = _matchbox_type_table.get_item()
		object.set_type(matchbox_type)
		object.move_to(Vector3(global_position.x + randi_range(min_x, max_x) + 0.5, global_position.y, global_position.z))
		object.connect("found_matches", _on_matchbox_found_matches)
		object.unpause()

func _on_matchbox_found_matches(matches: Array[MatchBox]) -> void:
	for matchbox in matches:
		remove_child(matchbox)
		matchbox.queue_free()
