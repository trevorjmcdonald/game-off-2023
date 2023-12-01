extends RigidBody3D
class_name Block

@export var block_mats: Array[Material] = []

@onready var meshinstance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	if block_mats.size() > 0:
		meshinstance.material_override = block_mats.pick_random()
