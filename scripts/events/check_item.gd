extends EventCommand
class_name CheckItemEvent

@export var item_id := ""
@export var amount := 1

@export var success_events:Array[EventCommand]
@export var fail_events:Array[EventCommand]

func execute(context):
	if Inventory.has_item(item_id, amount):
		await EventRunner.run(success_events, context)
	else:
		await EventRunner.run(fail_events, context)
