extends Node

func run(events: Array):
	for event in events:
		await event.execute()
