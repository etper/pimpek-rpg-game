extends CanvasLayer

enum MenuState {
	ROOT,
	INVENTORY,
	QUESTS,
	MAP,
	SETTINGS
}

@onready var title: Label = $Panel/Phone/HomeScreen/MarginContainer/VBoxContainer/Title

const APP_NAMES := [
	"INVENTORY",
	"QUESTS",
	"MAP",
	"SETTINGS"
]

const APP_ICONS := [
	preload("res://sprites/ui/mapAppIcon.png"),
	preload("res://sprites/ui/questAppIcon.png"),
	preload("res://sprites/ui/settingsAppIcon.png"),
	preload("res://sprites/ui/inventoryAppIcon.png")
]

@onready var phone = $Panel/Phone
@onready var home_screen = $Panel/Phone/HomeScreen
@onready var inventory_screen = $Panel/Phone/InventoryScreen
@onready var item_list = $Panel/Phone/InventoryScreen/ItemList

@onready var apps: Array[Button] = [
	$Panel/Phone/HomeScreen/MarginContainer/VBoxContainer/Apps/Inventory,
	$Panel/Phone/HomeScreen/MarginContainer/VBoxContainer/Apps/Quests,
	$Panel/Phone/HomeScreen/MarginContainer/VBoxContainer/Apps/Map,
	$Panel/Phone/HomeScreen/MarginContainer/VBoxContainer/Apps/Settings
]

var state := MenuState.ROOT
var selected := 0
var is_open := false

const COLUMNS := 2


func _ready():
	hide()

	Inventory.inventory_changed.connect(update_inventory)

	for i in apps.size():
		var button := apps[i]

		button.focus_mode = Control.FOCUS_NONE
		button.text = ""
		button.icon = APP_ICONS[i]
		button.expand_icon = true


func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		toggle()
		get_viewport().set_input_as_handled()


func toggle():
	is_open = !is_open
	visible = is_open

	if is_open:
		state = MenuState.ROOT
		selected = 0

		inventory_screen.hide()
		home_screen.show()
		phone.show()

		update_selection()
		animate_phone_open()


func _process(_delta):
	if !is_open:
		return

	if state == MenuState.ROOT:
		handle_phone_input()

	if Input.is_action_just_pressed("cancel"):
		go_back()


func handle_phone_input():
	var old_selected := selected

	if Input.is_action_just_pressed("move_right"):
		if selected % COLUMNS < COLUMNS - 1:
			selected += 1

	elif Input.is_action_just_pressed("move_left"):
		if selected % COLUMNS > 0:
			selected -= 1

	elif Input.is_action_just_pressed("move_down"):
		if selected + COLUMNS < apps.size():
			selected += COLUMNS

	elif Input.is_action_just_pressed("move_up"):
		if selected - COLUMNS >= 0:
			selected -= COLUMNS

	elif Input.is_action_just_pressed("interact"):
		activate()
		return

	if old_selected != selected:
		SoundManager.play_scroll()
		update_selection()


func update_selection():
	title.text = APP_NAMES[selected]

	for i in apps.size():
		var button := apps[i]

		if i == selected:
			button.scale = Vector2(1.08, 1.08)
			button.modulate = Color.WHITE
		else:
			button.scale = Vector2.ONE
			button.modulate = Color(0.65, 0.65, 0.65)


func activate():
	SoundManager.play_interact()

	match selected:
		0:
			open_inventory()

		1:
			print("Quests app")

		2:
			print("Map app")

		3:
			print("Settings app")


func open_inventory():
	state = MenuState.INVENTORY

	update_inventory()

	home_screen.hide()
	inventory_screen.show()


func update_inventory():
	item_list.clear()

	if Inventory.items.is_empty():
		item_list.add_text("Inventory is empty.")
		return

	for id in Inventory.items:
		var amount = Inventory.items[id]

		item_list.add_text(
			"%s x%d\n" % [id.capitalize(), amount]
		)


func go_back():
	match state:
		MenuState.ROOT:
			toggle()

		MenuState.INVENTORY:
			inventory_screen.hide()
			home_screen.show()
			phone.show()

			state = MenuState.ROOT
			update_selection()

		_:
			state = MenuState.ROOT
			phone.show()
			update_selection()


func animate_phone_open():
	phone.scale = Vector2(0.85, 0.85)
	phone.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		phone,
		"scale",
		Vector2.ONE,
		0.22
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		phone,
		"modulate:a",
		1.0,
		0.15
	)
