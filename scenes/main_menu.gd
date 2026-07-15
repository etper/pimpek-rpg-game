extends Control

@onready var options = [
	$"VBoxContainer/New Game",
	$"VBoxContainer/Continue",
	$"VBoxContainer/Settings",
	$"VBoxContainer/Quit",
]

@export var target_sprite: Sprite2D
@export var random_sprites: Array[RandomSprite]

var selected := 0

@onready var fade = $Fade

@onready var bg_music = $"BG Music"

const SAVE_PATH = "user://save.dat"

var has_save := false

func _ready():
	has_save = FileAccess.file_exists(SAVE_PATH)

	if !has_save:
		$"VBoxContainer/Continue".modulate = Color(0.5, 0.5, 0.5, 1.0)
	
	randomize()
	update_menu()
	choose_random_sprite()

func _unhandled_input(event):
	if event.is_action_pressed("move_down"):
		SoundManager.play_scroll()

		while true:
			selected = (selected + 1) % options.size()

			if has_save or selected != 1:
				break

		update_menu()

	elif event.is_action_pressed("move_up"):
		SoundManager.play_scroll()

		while true:
			selected = (selected - 1 + options.size()) % options.size()

			if has_save or selected != 1:
				break

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

	if !has_save:
		options[1].modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		options[1].modulate = Color.WHITE

func activate():
	match selected:
		0:
			await fade_to_black()
			get_tree().change_scene_to_file("res://main.tscn")

		1:
			if !has_save:
				return

		2:
			get_tree().change_scene_to_file("res://scenes/settings.tscn")

		3:
			get_tree().quit()

func fade_to_black():
	fade.color.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(fade, "color:a", 1.0, 3.5)
	tween.tween_property(bg_music, "volume_db", -80.0, 3.5)

	await tween.finished

func choose_random_sprite():
	if random_sprites.is_empty() or target_sprite == null:
		return

	var total := 0.0
	for entry in random_sprites:
		total += entry.chance

	var roll := randf() * total

	for entry in random_sprites:
		roll -= entry.chance
		if roll <= 0.0:
			target_sprite.texture = entry.texture
			return
