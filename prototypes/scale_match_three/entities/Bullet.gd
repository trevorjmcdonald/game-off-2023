extends AnimatableBody3D
class_name Bullet

var _velocity := Vector3.ZERO
var _power := 1

func initialize(velocity: Vector3, power: int = 1) -> void:
	_velocity = velocity
	_power = power

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(_velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is MatchBox:
			collider.move_x(_velocity.normalized() * _power)
			queue_free()
