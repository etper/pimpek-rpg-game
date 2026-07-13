extends EventCommand
class_name RemoveItemEvent

@export var item_id := ""
@export var amount := 1

func execute(_context):
	Inventory.remove_item(item_id, amount)
