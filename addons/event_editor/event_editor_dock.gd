@tool
extends VBoxContainer

@onready var list := $ItemList
@onready var add_button := $Button

var plugin: EditorPlugin

var selected_object

func _ready():
	print("Dock ready")
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
	print("Add Event")

func rebuild():
	list.clear()

	if selected_object == null:
		return

	if selected_object.get("events") == null:
		return

	for event in selected_object.events:
		list.add_item(event.get_script().resource_path.get_file())
