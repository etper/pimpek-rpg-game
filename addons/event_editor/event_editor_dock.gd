@tool
extends VBoxContainer

@onready var event_list := $ScrollContainer/EventList
@onready var add_button := $Button

const EventRow = preload("res://addons/event_editor/event_row.tscn")
const DialogueEvent = preload("res://scripts/events/dialogue_event.gd")

var plugin: EditorPlugin

var selected_object

func _ready():
	print("Dock ready")
	print(add_button)

	add_button.pressed.connect(_on_add_pressed)

func _process(_delta):
	var selection = plugin.get_editor_interface().get_selection().get_selected_nodes()

	if selection.is_empty():
		selected_object = null
		return

	if selection[0] != selected_object:
		selected_object = selection[0]
		print("Selected:", selected_object.name)
		rebuild()

func _on_add_pressed():
	print("Button pressed")

	if selected_object == null:
		print("No selected object")
		return

	print(selected_object)

	var events: Array = selected_object.events.duplicate()

	print("Before:", events.size())

	events.append(DialogueEvent.new())

	print("After:", events.size())

	selected_object.events = events

	rebuild()

func rebuild():
	for child in event_list.get_children():
		child.queue_free()

	if selected_object == null:
		return

	var events = selected_object.get("events")

	if events == null:
		return

	for event in events:
		var row = EventRow.instantiate()

		row.get_node("Name").text = event.get_display_name()

		event_list.add_child(row)


func _on_button_pressed():
	print("EDITOR CONNECTION")
