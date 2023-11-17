extends Node

@export var buddy: DeathScaleBuddy
@export var paused := false

func _process(_delta: float) -> void:
	if paused:
		return
	if not is_instance_valid(buddy):
		return

	buddy.start_ability_1()
