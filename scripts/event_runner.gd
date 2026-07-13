extends Node

func run(events: Array[EventCommand], context = null):
	for event in events:
		if event:
			await event.execute(context)
