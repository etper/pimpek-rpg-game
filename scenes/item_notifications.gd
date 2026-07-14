extends CanvasLayer

const ENTRY_SCENE = preload("res://scenes/item_notification.tscn")

@onready var list = $Margin/List

func show_notification(item_name: String, icon: Texture2D, amount: int, added: bool):
	var entry = ENTRY_SCENE.instantiate()

	list.add_child(entry)
	entry.setup(item_name, icon, amount, added)

func _ready():
	Inventory.item_feedback.connect(_on_item_feedback)

func _on_item_feedback(item_id: String, amount: int, added: bool):
	var data = ItemDatabase.ITEMS[item_id]

	show_notification(
		data["name"],
		null,
		amount,
		added
	)
