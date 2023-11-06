extends Resource
class_name MatchBoxType


@export var override_material: Material
@export var matches_with: Array[MatchBoxType]
@export var match_with_self: bool = true
@export var weight: int = 1 # likelihood of being selected


func is_match(other: MatchBoxType) -> bool:
	if match_with_self and self == other:
		return true
	return matches_with.find(other) != -1
