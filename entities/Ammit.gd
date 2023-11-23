extends Node3D
class_name Ammit

signal risen()
signal lowered()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var above_waypoint: Node3D = $Above
@onready var gullet_waypoint: Node3D = $Gullet

var _is_risen := false

func rise() -> void:
	if not _is_risen:
		_is_risen = true
		animation_player.play("rise")
		await animation_player.animation_finished
		risen.emit()

func lower() -> void:
	if _is_risen:
		_is_risen = false
		animation_player.play_backwards("rise")
		await animation_player.animation_finished
		lowered.emit()
