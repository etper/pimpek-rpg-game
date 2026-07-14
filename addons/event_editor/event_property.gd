@tool
extends EditorProperty

var edited_object
var property_name

const DialogueEvent = preload("res://scripts/events/dialogue_event.gd")

var list: VBoxContainer

func setup(obj, prop):
	edited_object = obj
	property_name = prop

	var root = VBoxContainer.new()
	root.name = "Root"
	add_child(root)

	list = VBoxContainer.new()
	root.add_child(list)

	var add_button = Button.new()
	add_button.text = "+ Add Event"
	add_button.pressed.connect(add_event)
	root.add_child(add_button)

	rebuild()

func rebuild():
	for child in list.get_children():
		list.remove_child(child)
		child.free()

	var events = edited_object.get(property_name)

	print("Children before:", list.get_child_count())

	for i in events.size():
		var label = Label.new()
		label.text = "Event %d" % i
		list.add_child(label)

	print("Children after:", list.get_child_count())
	print("Labels:", list.get_child_count())

func add_event():
	var events: Array = edited_object.get(property_name).duplicate()

	var event = DialogueEvent.new()
	event.text = "New Dialogue"

	events.append(event)

	edited_object.set(property_name, events)
	emit_changed(property_name, events)

	edited_object.notify_property_list_changed()

	rebuild()
