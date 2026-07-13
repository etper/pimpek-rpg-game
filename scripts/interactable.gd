@tool
extends Area2D

@export var sprite: Texture2D:
	set(value):
		sprite = value
		if has_node("Sprite2D"):
			$Sprite2D.texture = value

@export var events: Array[EventCommand]

var busy := false

@onready var sprite_node := $Sprite2D
@onready var shader_material := sprite_node.material as ShaderMaterial

func _ready():
	if sprite:
		sprite_node.texture = sprite

	if material:
		material.set_shader_parameter("enabled", false)


func set_highlight(value: bool):
	if material:
		material.set_shader_parameter("enabled", value)


func interact():
	if busy:
		return

	busy = true
	await EventRunner.run(events, self)
	busy = false
