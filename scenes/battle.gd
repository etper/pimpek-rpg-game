extends Node2D

@onready var menu_labels = [
	$Menu/Attack,
	$Menu/Item,
	$Menu/Run,
]

@onready var hp_label = $HPLabel

var selected := 0

func _ready():
	update_menu()
	update_hp()

func _unhandled_input(event):
	if Input.is_action_just_pressed("move_down"):
		selected = (selected + 1) % menu_labels.size()
		update_menu()

	elif Input.is_action_just_pressed("move_up"):
		selected = (selected - 1 + menu_labels.size()) % menu_labels.size()
		update_menu()

	elif Input.is_action_just_pressed("interact"):
		choose_option()

func update_menu():
	var names = [
		"Attack",
		"Item",
        "Run"
	]

	for i in menu_labels.size():
		menu_labels[i].text = ("> " if i == selected else "  ") + names[i]

func choose_option():
	match selected:
		0:
			print("Attack")
		1:
			print("Item")
		2:
			print("Run")

func update_hp():
	hp_label.text = "HP: %d/%d" % [
		PlayerStats.stats.hp,
		PlayerStats.stats.max_hp
	]
