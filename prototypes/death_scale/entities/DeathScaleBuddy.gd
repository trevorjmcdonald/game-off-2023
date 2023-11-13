extends CharacterBody3D
class_name DeathScaleBuddy

@export var blast_scene: PackedScene

var _movement := Vector3.ZERO
var _is_jumping := false
var _is_blasting := false
var _blast_timer := 0.0

func move(movement: Vector3) -> void:
	_movement = movement

func jump() -> void:
	if is_on_floor() and not _is_jumping:
		_is_jumping = true

func blast() -> void:
	if _blast_timer <= 0.0:
		_is_blasting = true

func _physics_process(delta: float) -> void:
	velocity.x = _movement.x * 5
	if is_on_floor() and _is_jumping:
		velocity.y = Vector3.UP.y * 10
		_is_jumping = false
	velocity += Vector3.DOWN * 20 * delta
	move_and_slide()

	if _is_blasting:
		_is_blasting = false
		_blast_timer = 1.0
		var new_blast: Node3D = blast_scene.instantiate()
		get_tree().root.add_child(new_blast)
		new_blast.global_position = global_position
	else:
		_blast_timer = maxf(_blast_timer - delta, 0)
