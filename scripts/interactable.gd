@tool
extends Area2D

@export var sprite: Texture2D:
	set(value):
		sprite = value
		if has_node("Sprite2D"):
			$Sprite2D.texture = value

@export var events: Array[EventCommand]

var busy := false

@onready var sprite_node = $Sprite2D

func _ready():
	if sprite:
		sprite_node.texture = sprite



func interact():
	if busy:
		return

	busy = true
	await EventRunner.run(events, self)
	busy = false
