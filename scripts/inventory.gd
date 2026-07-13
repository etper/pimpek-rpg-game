extends Node

signal inventory_changed

var items: Dictionary = {}
# Example:
# {
#     "apple": 3,
#     "key": 1
# }

func add_item(id: String, amount := 1):
	items[id] = items.get(id, 0) + amount
	inventory_changed.emit()

func remove_item(id: String, amount := 1) -> bool:
	if !items.has(id):
		return false

	if items[id] < amount:
		return false

	items[id] -= amount

	if items[id] <= 0:
		items.erase(id)

	inventory_changed.emit()
	return true

func has_item(id: String, amount := 1) -> bool:
	return items.get(id, 0) >= amount

func get_amount(id: String) -> int:
	return items.get(id, 0)
