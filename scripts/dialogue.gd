extends CanvasLayer

signal choice_selected(index)

@onready var box = $DialogueBox
@onready var label = $DialogueBox/MarginContainer/VBoxContainer/Label
@onready var options_label = $DialogueBox/MarginContainer/VBoxContainer/OptionsLabel

@export var letters_per_second := 40.0
@export var cursor := " ▶ "

var finished := false

var choosing := false
var selected := 0
var choices := []

@export var fast_text_multiplier := 4.0

@onready var portrait = $DialogueBox/Portrait
@onready var margin = $DialogueBox/MarginContainer

const NO_PORTRAIT_MARGIN = 0
const PORTRAIT_MARGIN = 264

func show_dialogue(text: String, expression: Texture2D = null):
	box.show()
	options_label.hide()

	if expression:
		portrait.texture = expression
		portrait.show()
		margin.add_theme_constant_override("margin_left", PORTRAIT_MARGIN)
	else:
		portrait.hide()
		margin.add_theme_constant_override("margin_left", NO_PORTRAIT_MARGIN)

	label.text = ""
	finished = false

	var char_count := 0

	for c in text:
		label.text += c

		if c != " " and c != "\n":
			char_count += 1

			if char_count % 2 == 0:
				SoundManager.play_text()

		var speed = letters_per_second
		if Input.is_action_pressed("sprint"):
			speed *= fast_text_multiplier

		await get_tree().create_timer(1.0 / speed).timeout

	finished = true

func show_choice(question: String, new_choices: Array):
	await show_dialogue(question)

	choices = new_choices
	selected = 0
	choosing = true

	options_label.show()

	while choosing:
		_update_options()

		if Input.is_action_just_pressed("move_down"):
			SoundManager.play_scroll()
			selected = (selected + 1) % choices.size()

		elif Input.is_action_just_pressed("move_up"):
			SoundManager.play_scroll()
			selected -= 1
			if selected < 0:
				selected = choices.size() - 1

		elif Input.is_action_just_pressed("interact"):
			SoundManager.play_interact()
			choosing = false

		await get_tree().process_frame

	options_label.hide()
	hide_dialogue()

	return selected

func _update_options():
	options_label.text = ""

	for i in choices.size():
		if i == selected:
			options_label.text += cursor
		else:
			options_label.text += "   "

		options_label.text += choices[i].text

		if i != choices.size() - 1:
			options_label.text += "\n"

func hide_dialogue():
	box.hide()
	options_label.hide()
