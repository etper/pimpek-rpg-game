extends Node

func run(events: Array[EventCommand], context):
	for event in events:
		if event != null:
			await event.execute(context)
