extends EventCommand
class_name PlaySoundEvent

@export var sound: AudioStream
@export_range(-80, 24) var volume_db := 0.0
@export var pitch_scale := 1.0
@export var wait_until_finished := false

func execute(context):
	if sound == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale

	context.add_child(player)
	player.play()

	if wait_until_finished:
		await player.finished

	player.queue_free()
