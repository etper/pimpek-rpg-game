extends CanvasLayer

@onready var labels = [
	$Panel/MarginContainer/VBoxContainer/Inventory,
]

enum MenuState {
	ROOT,
	INVENTORY,
	QUESTS,
	MAP,
	SETTINGS
}

var state := MenuState.ROOT
var selected := 0
var is_open := false

@onready var item_list = $Panel/InventoryPanel/ItemList

func _ready():
	hide()
	Inventory.inventory_changed.connect(update_inventory)

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
		
		
	if Input.is_action_just_pressed("cancel"):
		go_back()

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
			state = MenuState.INVENTORY
			update_inventory()
			$Panel/InventoryPanel.show()

		1:
			$Panel/InventoryPanel.hide()

func update_inventory():
	item_list.clear()

	if Inventory.items.is_empty():
		item_list.add_text("Inventory is empty.")
		return

	for id in Inventory.items:
		var amount = Inventory.items[id]
		item_list.add_text("%s x%d\n" % [id.capitalize(), amount])

func go_back():
	match state:
		MenuState.ROOT:
			toggle()

		MenuState.INVENTORY:
			$Panel/InventoryPanel.hide()
			state = MenuState.ROOT
