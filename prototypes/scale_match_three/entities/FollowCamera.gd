extends Camera3D
class_name FollowCamera

@export var target: Node3D
@export var bottom: Node3D
@export var top: Node3D

func _process(delta: float) -> void:
	if not target:
		return

	global_position.x = lerpf(global_position.x, target.global_position.x, delta)
	global_position.y = clamp(
		lerpf(
			global_position.y,
			target.global_position.y,
			delta),
		bottom.global_position.y,
		top.global_position.y)
