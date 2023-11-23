extends Node
class_name GameStateController

@export_file("*.tscn") var main_menu: String

@export var left_balance: Balance
@export var right_balance: Balance

@export var left_buddy: DeathScaleBuddy
@export var right_buddy: DeathScaleBuddy

@export var left_spawner: BlockSpawner
@export var right_spawner: BlockSpawner
@export var scale_manager: ScaleManager

@export var ammit: Ammit

@export var danger_zone: Area3D
@export var chomp_zone: Area3D

var _ending := false

func _ready() -> void:
	danger_zone.body_entered.connect(_on_danger_zone_body_entered)
	danger_zone.body_exited.connect(_on_danger_zone_body_exited)
	chomp_zone.body_entered.connect(_on_chomp_zone_body_entered)
	left_buddy.consumed.connect(_on_buddy_consumed.bind(left_buddy))
	right_buddy.consumed.connect(_on_buddy_consumed.bind(right_buddy))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			LevelController.request_quit()

func _on_danger_zone_body_entered(body: Node3D) -> void:
	if body == left_balance:
		print("left buddy in danger")
	elif body == right_balance:
		print("right buddy in danger")

func _on_danger_zone_body_exited(body: Node3D) -> void:
	if body == left_balance:
		print("left buddy no longer in danger")
	elif body == right_balance:
		print("right buddy no longer in danger")

func _on_chomp_zone_body_entered(body: Node3D) -> void:
	if body == left_balance:
		_begin_the_feed(left_buddy)
	elif body == right_balance:
		_begin_the_feed(right_buddy)

func _begin_the_feed(buddy: DeathScaleBuddy) -> void:
	if not _ending and is_instance_valid(buddy):
		_ending = true
		ammit.rise()
		scale_manager.pause()
		left_buddy.pause()
		right_buddy.pause()
		left_spawner.pause()
		right_spawner.pause()
		buddy.be_consumed(ammit)

func _on_buddy_consumed(_buddy: DeathScaleBuddy) -> void:
	ammit.lower()
	danger_zone.body_entered.disconnect(_on_danger_zone_body_entered)
	danger_zone.body_exited.disconnect(_on_danger_zone_body_exited)
	chomp_zone.body_entered.disconnect(_on_chomp_zone_body_entered)
	left_buddy.consumed.disconnect(_on_buddy_consumed.bind(left_buddy))
	right_buddy.consumed.disconnect(_on_buddy_consumed.bind(right_buddy))
	await ammit.lowered
	LevelController.request_level(main_menu)
