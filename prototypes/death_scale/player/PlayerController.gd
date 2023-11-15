extends Node

@export var buddy: DeathScaleBuddy

func _process(_delta: float) -> void:
	if not is_instance_valid(buddy):
		return

	var movement := Vector3.ZERO
	movement.x = Input.get_axis("player1_move_left", "player1_move_right")
	buddy.move(movement)

	if Input.is_action_pressed("player1_jump"):
		buddy.jump()
	if Input.is_action_pressed("player1_ability_1"):
		buddy.blast()
