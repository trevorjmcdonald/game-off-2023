extends Area3D
class_name DeathZone

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is MatchBuddy:
		body.murder()
