extends BuddyAbility

@export var projectile_scene: PackedScene

@onready var cooldown: Timer = $Cooldown

var _firing := false
var _ready_to_fire := true

func start_ability() -> void:
	_firing = true

func stop_ability() -> void:
	_firing = false

func _ready() -> void:
	cooldown.timeout.connect(_on_cooldown_timeout)

func _process(_delta: float) -> void:
	if not _ready_to_fire:
		return

	if _firing:
		_ready_to_fire = false
		cooldown.start()
		var projectile: SmiteProjectile = projectile_scene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_position = global_position
		var direction := Vector3.RIGHT
		if (global_position - buddy.global_position).x < 0.:
			direction = Vector3.LEFT
		projectile.set_velocity(direction * 5)

func _on_cooldown_timeout() -> void:
	_ready_to_fire = true
