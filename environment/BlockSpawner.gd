extends Node3D
class_name BlockSpawner

@export var default_block_scene: PackedScene
@export var big_block_scene: PackedScene

@onready var spawn_timer: Timer = $Timer

@onready var _spawn_timeout := spawn_timer.wait_time
@onready var _current_block_scene: PackedScene = default_block_scene

var _spawn_rate := 1.

func pause() -> void:
	spawn_timer.paused = true

func unpause() -> void:
	spawn_timer.paused = false
	if spawn_timer.is_stopped():
		spawn_timer.start()

func set_spawn_rate(spawn_rate: float = 1.) -> void:
	_spawn_rate = clampf(spawn_rate, 0.1, 5.)
	spawn_timer.wait_time = _spawn_timeout / _spawn_rate

func spawn_default_blocks() -> void:
	_current_block_scene = default_block_scene

func spawn_big_blocks() -> void:
	_current_block_scene = big_block_scene

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	_spawn_block()

func _spawn_block() -> void:
	if _current_block_scene:
		var block := _current_block_scene.instantiate() as Block
		get_tree().root.add_child(block)
		block.global_position = global_position
		block.apply_central_impulse(Vector3.RIGHT * randf_range(-2., 2.))
