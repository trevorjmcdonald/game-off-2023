extends Node
class_name PlayerController

@export var buddy: DeathScaleBuddy
@export var jump: StringName
@export var crouch: StringName
@export var move_left: StringName
@export var move_right: StringName
@export var ability_1: StringName
@export var ability_2: StringName
@export var ability_3: StringName

@export var paused := false

func _process(_delta: float) -> void:
	if paused:
		return

	if not is_instance_valid(buddy):
		return

	if move_left and move_right:
		var movement := Vector3.ZERO
		movement.x = Input.get_axis(move_left, move_right)
		buddy.move(movement)
	if jump:
		if Input.is_action_just_pressed(jump):
			buddy.start_jump()
		elif Input.is_action_just_released(jump):
			buddy.stop_jump()
	if crouch:
		if Input.is_action_just_pressed(crouch):
			buddy.start_crouch()
		elif Input.is_action_just_released(crouch):
			buddy.stop_crouch()
	if ability_1:
		if Input.is_action_just_pressed(ability_1):
			buddy.start_ability_1()
		elif Input.is_action_just_released(ability_1):
			buddy.stop_ability_1()
	if ability_2:
		if Input.is_action_just_pressed(ability_2):
			buddy.start_ability_2()
		elif Input.is_action_just_released(ability_2):
			buddy.stop_ability_2()
	if ability_3:
		if Input.is_action_just_pressed(ability_3):
			buddy.start_ability_3()
		elif Input.is_action_just_released(ability_3):
			buddy.stop_ability_3()
