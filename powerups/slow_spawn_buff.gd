extends PowerUp

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func pickup(buddy: DeathScaleBuddy) -> void:
	if powerup_controller:
		powerup_controller.apply_slow_spawn_buff(buddy)
		audio_player.play()
		set_deferred("monitoring", false)
		set_deferred("visible", false)
		await audio_player.finished
		queue_free()
