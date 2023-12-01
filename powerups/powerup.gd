extends Area3D
class_name PowerUp

var powerup_controller: PowerUpController

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func set_powerup_controller(controller: PowerUpController) -> void:
	powerup_controller = controller

func pickup(_buddy: DeathScaleBuddy) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is DeathScaleBuddy:
		pickup(body)
