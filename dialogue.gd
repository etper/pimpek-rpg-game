extends CanvasLayer

@onready var box = $DialogueBox
@onready var label = $DialogueBox/MarginContainer/Label

func show_dialogue(text: String):
	label.text = text
	box.show()

func hide_dialogue():
	box.hide()
