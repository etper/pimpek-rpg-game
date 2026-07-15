extends Node

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)

func play(stream: AudioStream):
	if player.stream == stream and player.playing:
		return

	player.volume_db = 0
	player.stream = stream
	player.play()

func stop():
	player.stop()

func fade_out(duration := 1.0):
	if !player.playing:
		return

	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80.0, duration)
	await tween.finished

	player.stop()
	player.volume_db = 0
