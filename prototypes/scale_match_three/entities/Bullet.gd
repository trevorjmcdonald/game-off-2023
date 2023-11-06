extends AnimatableBody3D
class_name Bullet

@export var speed := 10.0
@export var power := 1

var _move_direction := Vector3.ZERO

func set_move_direction(dir: Vector3) -> void:
	_move_direction.x = dir.normalized().x

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector3.UP * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is MatchBox:
			collider.move_x(_move_direction * power)
			queue_free()
