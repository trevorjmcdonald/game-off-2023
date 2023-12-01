extends Node
class_name PowerUpController

@export var left_block_spawner: BlockSpawner
@export var right_block_spawner: BlockSpawner

@export var left_buddy: DeathScaleBuddy
@export var right_buddy: DeathScaleBuddy

@export var spawn_position: Node3D
@export var powerups: Array[PackedScene] = []

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func pause() -> void:
	spawn_timer.paused = true

func unpause() -> void:
	spawn_timer.paused = false
	if spawn_timer.is_stopped():
		spawn_timer.start()

func apply_big_block_debuff(grabbist: DeathScaleBuddy) -> void:
	var spawner: BlockSpawner
	if grabbist == left_buddy:
		spawner = right_block_spawner
	else:
		spawner = left_block_spawner
	spawner.spawn_big_blocks()
	await get_tree().create_timer(8.0).timeout
	spawner.spawn_default_blocks()
	spawn_timer.start()

func apply_slow_spawn_buff(grabbist: DeathScaleBuddy) -> void:
	var spawner: BlockSpawner
	if grabbist == left_buddy:
		spawner = left_block_spawner
	else:
		spawner = right_block_spawner
	spawner.set_spawn_rate(0.5)
	await get_tree().create_timer(8.0).timeout
	spawner.set_spawn_rate(1.0)
	spawn_timer.start()

func apply_fast_spawn_debuff(grabbist: DeathScaleBuddy) -> void:
	var spawner: BlockSpawner
	if grabbist == left_buddy:
		spawner = right_block_spawner
	else:
		spawner = left_block_spawner
	spawner.set_spawn_rate(5.0)
	await get_tree().create_timer(8.0).timeout
	spawner.set_spawn_rate(1.0)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if spawn_position and powerups.size() > 0:
		var powerup_scene: PackedScene = powerups.pick_random()
		var powerup := powerup_scene.instantiate() as PowerUp
		if powerup:
			spawn_position.add_child(powerup)
			powerup.set_powerup_controller(self)
