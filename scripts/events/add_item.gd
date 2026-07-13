extends EventCommand
class_name AddItemEvent

@export var item_id := ""
@export var amount := 1

func execute(_context):
	Inventory.add_item(item_id, amount)
