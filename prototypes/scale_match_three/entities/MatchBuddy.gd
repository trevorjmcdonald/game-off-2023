extends CharacterBody3D
class_name MatchBuddy

signal died()

@export var move_speed := 10
@export var gravity := 10
@export var jump_power := 10

@export var bullet_scene: PackedScene

var _facing := Vector3.RIGHT

func murder() -> void:
	emit_signal("died")
	queue_free()

func crush() -> void:
	if is_on_floor():
		murder()

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if bullet_scene:
			var bullet := bullet_scene.instantiate() as Bullet
			if bullet:
				get_parent().add_child(bullet)
				bullet.global_position = Vector3(global_position.x, global_position.y, global_position.z) + _facing * 0.1
				bullet.initialize(_facing * 20)

	var movement := Vector3.ZERO
	if Input.is_action_pressed("move_left"):
		movement += Vector3.LEFT * move_speed
		_facing = Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		movement += Vector3.RIGHT * move_speed
		_facing = Vector3.RIGHT
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		movement += Vector3.UP * jump_power

	movement.y += velocity.y - gravity * delta

	velocity = movement

	move_and_slide()

