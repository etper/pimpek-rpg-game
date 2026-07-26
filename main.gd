extends Node2D

const ROOM_MUSIC = preload("res://music/Pimpek Room.mp3")

@onready var fade: ColorRect = $Fade

func _ready():
	# Start completely black
	fade.color = Color(0, 0, 0, 1)

	# Start the area's music
	MusicManager.play(ROOM_MUSIC)

	# Fade the game into view
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, 4.0)

	# Fade music in at the same time
	MusicManager.fade_in(4.0)

	await tween.finished
	fade.hide()
