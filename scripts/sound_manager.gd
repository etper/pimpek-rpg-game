extends Node

const INTERACT = preload("res://sfx/interact.wav")
const SCROLL = preload("res://sfx/scroll.wav")
const TEXT = preload("res://sfx/dialogue scroll.wav")

func play_text():
	var player := AudioStreamPlayer.new()
	player.stream = TEXT
	player.volume_db = -15
	player.pitch_scale = randf_range(0.95, 1.05) # optional
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_interact():
	var player := AudioStreamPlayer.new()
	player.stream = INTERACT
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_scroll():
	var player := AudioStreamPlayer.new()
	player.stream = SCROLL
	player.volume_db = -10
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
