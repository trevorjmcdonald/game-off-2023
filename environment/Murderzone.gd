extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.queue_free()
	elif body is DeathScaleBuddy:
		body.return_to_spawn()
