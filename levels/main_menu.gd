extends Node2D

@export_file("*.tscn") var one_player_scene: String
@export_file("*.tscn") var two_player_scene: String

@onready var one_player_button: Button = %OnePlayer
@onready var two_player_button: Button = %TwoPlayer
@onready var quit_button: Button = %Quit

func _ready() -> void:
	one_player_button.button_down.connect(_on_one_player_button_click)
	two_player_button.button_down.connect(_on_two_player_button_click)
	quit_button.button_down.connect(_on_quit_button_click)

func _on_one_player_button_click() -> void:
	if one_player_scene:
		LevelController.request_level(one_player_scene)
		pass

func _on_two_player_button_click() -> void:
	if two_player_scene:
		LevelController.request_level(two_player_scene)
		pass

func _on_quit_button_click() -> void:
	LevelController.request_quit()
