extends Node

var busy := false

func run(events: Array[EventCommand], context):
	busy = true

	for event in events:
		if event != null:
			await event.execute(context)

	busy = false
