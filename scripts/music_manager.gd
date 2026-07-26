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

func fade_in(duration := 1.0):
	if !player.playing:
		return

	var music_bus := AudioServer.get_bus_index("Music")

	# User has Music at 0% — don't fade anything in.
	if AudioServer.get_bus_volume_db(music_bus) <= -80.0:
		player.volume_db = 0.0
		return

	player.volume_db = -80.0

	var tween = create_tween()
	tween.tween_property(player, "volume_db", 0.0, duration)

	await tween.finished
