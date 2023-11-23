extends Node3D
class_name BuddyAbility


@export var buddy: DeathScaleBuddy

var _paused := false

func pause() -> void:
	_paused = true

func unpause() -> void:
	_paused = false

func start_ability() -> void:
	pass

func stop_ability() -> void:
	pass
