extends Node3D
class_name Spawner

##### Signals
signal object_spawned(object : Node)


##### Exports
@export var spawn_object : PackedScene
@export var spawn_parent : Node


##### OnReady
@onready var spawn_timer : Timer = $Timer


##### Variables


##### Public Methods


##### Private Methods


##### Overrides
func _ready():
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	spawn_timer.start()


##### Event Handlers
func _on_spawn_timer_timeout():
	if spawn_object:
		var obj = spawn_object.instantiate() as MatchBox
		spawn_parent.add_child(obj)
		emit_signal("object_spawned", obj)
