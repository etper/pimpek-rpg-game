extends Control

@onready var labels = [
	$VBoxContainer/Master,
	$VBoxContainer/Music,
	$VBoxContainer/SFX,
	$VBoxContainer/Back
]

var selected := 0

var master := 50
var music := 50
var sfx := 50

# ADD THESE
const INITIAL_REPEAT_DELAY := 0.25
const REPEAT_INTERVAL := 0.06
const MAX_STEP := 8

var hold_dir := 0
var hold_time := 0.0
var repeat_timer := 0.0

const MAIN_MENU_MUSIC = preload("res://music/Main Menu.mp3")

func _ready():
	master = roundi(db_to_linear(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	) * 100)

	music = roundi(db_to_linear(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	) * 100)

	sfx = roundi(db_to_linear(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	) * 100)

	update_menu()
	MusicManager.play(MAIN_MENU_MUSIC)

func _process(delta):
	if hold_dir == 0:
		return

	hold_time += delta
	repeat_timer -= delta

	if repeat_timer <= 0.0:
		var step := mini(1 + int(hold_time * 4.0), MAX_STEP)
		change_value(hold_dir * step)
		repeat_timer = REPEAT_INTERVAL

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
		hold_dir = -1
		hold_time = 0.0
		repeat_timer = INITIAL_REPEAT_DELAY
		change_value(-1)

	elif event.is_action_pressed("move_right"):
		SoundManager.play_interact()
		hold_dir = 1
		hold_time = 0.0
		repeat_timer = INITIAL_REPEAT_DELAY
		change_value(1)

	elif event.is_action_released("move_left") and hold_dir == -1:
		hold_dir = 0

	elif event.is_action_released("move_right") and hold_dir == 1:
		hold_dir = 0

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
	set_bus_volume("Master", master)
	set_bus_volume("Music", music)
	set_bus_volume("SFX", sfx)

func set_bus_volume(bus_name: String, value: int):
	var bus := AudioServer.get_bus_index(bus_name)

	if value <= 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear_to_db(value / 100.0))
