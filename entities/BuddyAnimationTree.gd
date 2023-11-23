extends AnimationTree

@export var buddy: DeathScaleBuddy

@onready var state_machine: AnimationNodeStateMachinePlayback = self["parameters/playback"]

var is_jumping: bool
var is_moving: bool
var is_grounded: bool
var is_crouched: bool
var is_falling: bool
var is_in_spirit_form: bool

func _update_animation_params() -> void:
	is_moving = absf(buddy.velocity.x) > 0.1
	is_jumping = buddy._is_jumping
	is_grounded = buddy.is_on_floor()

func _ready() -> void:
	buddy.jumped.connect(_on_jumped)
	buddy.landed.connect(_on_landed)
	buddy.falling.connect(_on_falling)
	buddy.crouched.connect(_on_crouched)
	buddy.stood.connect(_on_stood)
	buddy.entered_spirit_form.connect(_on_entered_spirit_form)
	buddy.exited_spirit_form.connect(_on_exited_spirit_form)

func _process(_delta: float) -> void:
	_update_animation_params()

func _on_jumped() -> void:
	is_jumping = true

func _on_landed() -> void:
	is_falling = false
	is_jumping = false

func _on_falling() -> void:
	is_jumping = false
	is_falling = true

func _on_crouched() -> void:
	is_crouched = true

func _on_stood() -> void:
	is_crouched = false

func _on_entered_spirit_form() -> void:
	state_machine.travel("spirit_form")

func _on_exited_spirit_form() -> void:
	state_machine.travel("idle")
