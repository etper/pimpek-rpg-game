@tool
extends Area2D

@export var sprite: Texture2D:
	set(value):
		sprite = value
		if has_node("Sprite2D"):
			$Sprite2D.texture = value

@export var events: Array[EventCommand]

var busy := false

func _ready():
	if sprite:
		$Sprite2D.texture = sprite

func interact():
	if busy:
		return

	busy = true
	await EventRunner.run(events, self)
	busy = false
