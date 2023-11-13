extends Node

@export var buddy: DeathScaleBuddy

func _process(_delta: float) -> void:
	if is_instance_valid(buddy):
		buddy.blast()
