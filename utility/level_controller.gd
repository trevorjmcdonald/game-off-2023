# https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
extends Node

var _current_scene: Node = null

func _ready() -> void:
	_get_current_scene()

func request_level(path: String) -> void:
	call_deferred("_load_scene", path)

func request_quit() -> void:
	get_tree().quit()

func _load_scene(path: String) -> void:
	if not _current_scene:
		_get_current_scene()

	_current_scene.free()
	var new_scene = ResourceLoader.load(path)
	_current_scene = new_scene.instantiate()
	get_tree().root.add_child(_current_scene)
	get_tree().current_scene = _current_scene

func _get_current_scene() -> void:
	var root := get_tree().root
	_current_scene = root.get_child(root.get_child_count() - 1)
