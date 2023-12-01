extends AnimatableBody3D
class_name SmiteProjectile

@export var power := 4.

@export var shot_sfx: Array[AudioStream] = []
@export var explosion_sfx: Array[AudioStream] = []

@onready var blast_area: Area3D = $BlastArea
@onready var detonation_area: Area3D = $DetonationArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _velocity := Vector3.ZERO
var _is_detonating := false

func set_velocity(velocity: Vector3) -> void:
	_velocity = velocity

func detonate() -> void:
	if _is_detonating:
		return

	_is_detonating = true
	detonation_area.set_deferred("monitoring", false)
	blast_area.set_deferred("monitoring", true)
	animation_player.play("explosion")
	audio_player.stop()
	if explosion_sfx.size() > 0:
		audio_player.stream = explosion_sfx.pick_random()
		audio_player.play()

func _ready() -> void:
	blast_area.body_entered.connect(_on_blast_area_body_entered)
	detonation_area.body_entered.connect(_on_detonation_area_body_entered)

	if shot_sfx.size() > 0:
		audio_player.stream = shot_sfx.pick_random()
		audio_player.play()

func _physics_process(delta: float) -> void:
	if not _is_detonating:
		position += _velocity * delta

func _on_detonation_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		detonate()

func _on_blast_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.apply_impulse(_velocity * power * scale.x)
