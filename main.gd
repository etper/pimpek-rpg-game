extends Node2D

const ROOM_MUSIC = preload("res://music/Pimpek Room.mp3")

@onready var fade: ColorRect = $UI/Fade

func _ready():
	# Make sure black overlay is visible first.
	fade.show()
	fade.color = Color(0, 0, 0, 1)

	MusicManager.play(ROOM_MUSIC)

	# Allow one fully black frame to render.
	await get_tree().process_frame

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(fade, "color:a", 0.0, 4.0)
	MusicManager.fade_in(4.0)

	await tween.finished
	fade.hide()
