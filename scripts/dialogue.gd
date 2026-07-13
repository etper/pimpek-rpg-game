extends CanvasLayer

@onready var box = $DialogueBox
@onready var label = $DialogueBox/MarginContainer/Label

@export var letters_per_second := 40.0

var finished := false

func show_dialogue(text: String):
	box.show()
	label.text = ""
	finished = false

	for c in text:
		label.text += c
		await get_tree().create_timer(1.0 / letters_per_second).timeout

	finished = true

func hide_dialogue():
	box.hide()
