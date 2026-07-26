extends Control

@onready var video: VideoStreamPlayer = $Video

func _ready():
	MusicManager.stop()
	video.finished.connect(_on_video_finished)
	video.play()


func _on_video_finished():
	get_tree().change_scene_to_file("res://main.tscn")
