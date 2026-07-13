extends CanvasLayer

@onready var labels = [
	$Panel/MarginContainer/VBoxContainer/Inventory,
]

var selected := 0
var is_open := false

func _ready():
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		toggle()

func toggle():
	is_open = !is_open

	visible = is_open
	#get_tree().paused = is_open

	if is_open:
		selected = 0
		update_selection()

func _process(_delta):
	if !is_open:
		return

	if Input.is_action_just_pressed("move_down"):
		selected = (selected + 1) % labels.size()
		update_selection()

	elif Input.is_action_just_pressed("move_up"):
		selected = (selected - 1 + labels.size()) % labels.size()
		update_selection()

	elif Input.is_action_just_pressed("interact"):
		activate()

func update_selection():
	var names = [
		"Inventory",
		"Quests",
		"Map",
        "Settings"
	]

	for i in labels.size():
		labels[i].text = ("> " if i == selected else "  ") + names[i]

func activate():
	match selected:
		0:
			print("Inventory")
		1:
			print("Quests")
		2:
			print("Map")
		3:
			print("Settings")
