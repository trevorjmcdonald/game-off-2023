extends Node
class_name GameStateController

@export var left_balance: Balance
@export var right_balance: Balance

@export var left_buddy: DeathScaleBuddy
@export var right_buddy: DeathScaleBuddy

@export var ammit: Ammit

@export var danger_zone: Area3D
@export var chomp_zone: Area3D

func _ready() -> void:
	danger_zone.body_entered.connect(_on_danger_zone_body_entered)
	danger_zone.body_exited.connect(_on_danger_zone_body_exited)
	chomp_zone.body_entered.connect(_on_chomp_zone_body_entered)

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
		if is_instance_valid(left_buddy):
			ammit.rise()
			right_buddy.be_consumed(ammit)
	elif body == right_balance:
		if is_instance_valid(right_buddy):
			ammit.rise()
			right_buddy.be_consumed(ammit)
