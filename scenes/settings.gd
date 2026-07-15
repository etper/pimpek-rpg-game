extends Control

@onready var labels = [
	$VBoxContainer/Master,
	$VBoxContainer/Music,
	$VBoxContainer/SFX,
	$VBoxContainer/Back
]

var selected := 0

var master := 100
var music := 100
var sfx := 100

const MAIN_MENU_MUSIC = preload("res://music/Main Menu.mp3")

func _ready():
	update_menu()
	MusicManager.play(MAIN_MENU_MUSIC)

func _unhandled_input(event):
	if event.is_action_pressed("move_down"):
		selected = (selected + 1) % labels.size()
		SoundManager.play_scroll()
		update_menu()

	elif event.is_action_pressed("move_up"):
		selected = (selected - 1 + labels.size()) % labels.size()
		SoundManager.play_scroll()
		update_menu()

	elif event.is_action_pressed("move_left"):
		SoundManager.play_interact()
		change_value(-10)

	elif event.is_action_pressed("move_right"):
		SoundManager.play_interact()
		change_value(10)

	elif event.is_action_pressed("interact"):
		if selected == 3:
			get_tree().change_scene_to_file("res://scenes/main menu.tscn")

	elif event.is_action_pressed("cancel"):
		get_tree().change_scene_to_file("res://scenes/main menu.tscn")

func change_value(amount):
	match selected:
		0:
			master = clamp(master + amount, 0, 100)
		1:
			music = clamp(music + amount, 0, 100)
		2:
			sfx = clamp(sfx + amount, 0, 100)

	apply_audio()
	update_menu()

func update_menu():
	labels[0].text = ("%sMaster Volume: %d%%" %
		["> " if selected == 0 else "  ", master])

	labels[1].text = ("%sMusic Volume: %d%%" %
		["> " if selected == 1 else "  ", music])

	labels[2].text = ("%sSFX Volume: %d%%" %
		["> " if selected == 2 else "  ", sfx])

	labels[3].text = ("> Back" if selected == 3 else "  Back")

func apply_audio():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(master / 100.0)
	)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(music / 100.0)
	)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(sfx / 100.0)
	)
