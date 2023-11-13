extends AnimatableBody3D
class_name Balance

@onready var rigidboy_monitor: Area3D = $Area3D

var _monitored_bodies: Array[RigidBody3D] = []

func calculate_total_mass() -> float:
	var total_mass := 0.0
	for i in range(_monitored_bodies.size() - 1, -1, -1):
		var body := _monitored_bodies[i]
		if not is_instance_valid(body):
			_monitored_bodies.remove_at(i)
			continue
		#var space_state := get_world_3d().direct_space_state
		#var query := PhysicsRayQueryParameters3D.create(body.global_position, body.global_position + Vector3.DOWN * 0.75)
		#query.exclude.append(body.get_rid())
		#var result := space_state.intersect_ray(query)
		#if result:
		#	total_mass += body.mass
		if abs(body.linear_velocity.y) < 0.1:
			total_mass += body.mass
	return total_mass

func _ready() -> void:
	rigidboy_monitor.body_entered.connect(on_rigidbody_monitor_body_entered)
	rigidboy_monitor.body_exited.connect(on_rigidbody_monitor_body_exited)

func on_rigidbody_monitor_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		if _monitored_bodies.find(body) == -1:
			_monitored_bodies.append(body)

func on_rigidbody_monitor_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		var index := _monitored_bodies.find(body)
		if index != -1:
			_monitored_bodies.remove_at(index)
