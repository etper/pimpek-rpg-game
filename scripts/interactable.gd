extends Area2D

@export var events: Array[EventCommand]

var busy := false

func interact():
	if busy:
		return

	busy = true
	await EventRunner.run(events, self)
	busy = false
