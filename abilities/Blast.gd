extends Area3D

@export var force := 10.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.apply_central_impulse((body.global_position - global_position).normalized() * force)
