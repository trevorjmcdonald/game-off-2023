extends Node3D

@export var block_scene: PackedScene

@export var action: StringName

@onready var spawn_timer: Timer = $Timer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed(action):
	#	_spawn_block()
		#if spawn_timer.is_stopped():
		#	spawn_timer.start()
		#else:
		#	spawn_timer.stop()

func _on_spawn_timer_timeout() -> void:
	_spawn_block()

func _spawn_block() -> void:
	if block_scene:
		var block: Node3D = block_scene.instantiate()
		get_tree().root.add_child(block)
		block.global_position = global_position
