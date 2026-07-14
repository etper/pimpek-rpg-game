extends Control

@onready var options = [
	$"VBoxContainer/New Game",
	$"VBoxContainer/Continue",
	$"VBoxContainer/Settings",
	$"VBoxContainer/Quit",
]

var selected := 0

@onready var fade = $Fade

func _ready():
	update_menu()

func _unhandled_input(event):
	if event.is_action_pressed("move_down"):
		SoundManager.play_scroll()
		selected = (selected + 1) % options.size()
		update_menu()

	elif event.is_action_pressed("move_up"):
		SoundManager.play_scroll()
		selected = (selected - 1 + options.size()) % options.size()
		update_menu()

	elif event.is_action_pressed("interact"):
		SoundManager.play_interact()
		activate()

func update_menu():
	var names = [
		"NEW GAME",
		"CONTINUE",
		"SETTINGS",
        "QUIT"
	]

	for i in options.size():
		options[i].text = ("> " if i == selected else "  ") + names[i]

func activate():
	match selected:
		0:
			await fade_to_black()
			get_tree().change_scene_to_file("res://main.tscn")

		1:
			print("Continue")

		2:
			print("Settings")

		3:
			get_tree().quit()

func fade_to_black():
	fade.color.a = 0.0

	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 3.5)

	await tween.finished
