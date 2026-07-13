extends CanvasLayer

signal choice_selected(index)

@onready var box = $DialogueBox
@onready var label = $DialogueBox/MarginContainer/Label
@onready var options_label = $DialogueBox/MarginContainer/OptionsLabel

@export var letters_per_second := 40.0
@export var cursor := "▶ "

var finished := false

var choosing := false
var selected := 0
var choices := []

func show_dialogue(text: String):
	box.show()
	options_label.hide()

	label.text = ""
	finished = false

	for c in text:
		label.text += c
		await get_tree().create_timer(1.0 / letters_per_second).timeout

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
			selected = (selected + 1) % choices.size()

		elif Input.is_action_just_pressed("move_up"):
			selected -= 1
			if selected < 0:
				selected = choices.size() - 1

		elif Input.is_action_just_pressed("interact"):
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
