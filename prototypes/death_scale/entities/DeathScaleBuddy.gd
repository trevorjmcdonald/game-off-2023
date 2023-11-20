extends PlatformerController3D
class_name DeathScaleBuddy

@export var ability_1: BuddyAbility
@export var ability_2: BuddyAbility
@export var ability_3: BuddyAbility

@onready var animation_tree := $AnimationTree

func start_ability_1() -> void:
	if ability_1:
		ability_1.start_ability()

func stop_ability_1() -> void:
	if ability_1:
		ability_1.stop_ability()

func start_ability_2() -> void:
	if ability_2:
		ability_2.start_ability()

func stop_ability_2() -> void:
	if ability_2:
		ability_2.stop_ability()

func start_ability_3() -> void:
	if ability_3:
		ability_3.start_ability()

func stop_ability_3() -> void:
	if ability_3:
		ability_3.stop_ability()

func _ready() -> void:
	_calculate_jump_params() # since we can't call the base _ready
	jumped.connect(_on_jumped)
	landed.connect(_on_landed)
	falling.connect(_on_falling)
	crouched.connect(_on_crouched)
	stood.connect(_on_stood)

func _process(_delta: float) -> void:
	_set_facing()
	_update_animation_params()

func _set_facing() -> void:
	match signf(_movement.x):
		1.0:
			rotation.y = 0
		-1.0:
			rotation.y = deg_to_rad(180)

func _update_animation_params() -> void:
	var is_moving := not absf(velocity.x) < 0.1
	animation_tree["parameters/conditions/is_moving"] = is_moving
	animation_tree["parameters/conditions/is_idle"] = not is_moving

func _on_jumped() -> void:
	animation_tree["parameters/conditions/is_jumping"] = true
	animation_tree["parameters/conditions/is_grounded"] = false

func _on_landed() -> void:
	animation_tree["parameters/conditions/is_jumping"] = false
	animation_tree["parameters/conditions/is_grounded"] = true

func _on_falling() -> void:
	# some kind of falling animation maybe?
	pass

func _on_crouched() -> void:
	animation_tree["parameters/conditions/is_crouched"] = true
	animation_tree["parameters/conditions/is_standing"] = false
	animation_tree["parameters/conditions/is_jumping"] = false
	animation_tree["parameters/conditions/is_grounded"] = true

func _on_stood() -> void:
	animation_tree["parameters/conditions/is_crouched"] = false
	animation_tree["parameters/conditions/is_standing"] = true
