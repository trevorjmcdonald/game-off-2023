extends Node3D
class_name Ammit

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var above_waypoint: Node3D = $Above
@onready var gullet_waypoint: Node3D = $Gullet

var _is_risen := false

func rise() -> void:
	if not _is_risen:
		animation_player.play("rise")
		print("rising")
		_is_risen = true

func lower() -> void:
	if _is_risen:
		animation_player.play_backwards("rise")
		print("un-rising")
		_is_risen = false
