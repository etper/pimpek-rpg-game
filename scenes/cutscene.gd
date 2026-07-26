extends Control

@onready var video: VideoStreamPlayer = $Video

var leaving := false

func _ready():
	MusicManager.stop()
	video.finished.connect(_finish_cutscene)
	video.play()

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		_finish_cutscene()

func _finish_cutscene():
	if leaving:
		return

	leaving = true
	video.stop()
	get_tree().change_scene_to_file("res://main.tscn")
