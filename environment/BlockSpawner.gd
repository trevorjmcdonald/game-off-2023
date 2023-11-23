extends Node3D
class_name BlockSpawner

@export var block_scene: PackedScene

@onready var spawn_timer: Timer = $Timer

@onready var _spawn_timeout := spawn_timer.wait_time

var _spawn_rate := 1.0

func pause() -> void:
	spawn_timer.paused = true

func unpause() -> void:
	spawn_timer.paused = false

func set_spawn_rate(spawn_rate: float) -> void:
	_spawn_rate = spawn_rate
	spawn_timer.wait_time = _spawn_timeout * _spawn_rate

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	_spawn_block()

func _spawn_block() -> void:
	if block_scene:
		var block: Node3D = block_scene.instantiate()
		get_tree().root.add_child(block)
		block.global_position = global_position
