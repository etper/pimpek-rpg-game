extends Node2D

@onready var intro = $IntroNPC

func _ready():
	await get_tree().process_frame
	intro.interact()   # or whatever your interact function is called
