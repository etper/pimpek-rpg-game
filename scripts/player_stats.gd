extends Node

var stats := CharacterStats.new()

func _ready():
	stats.max_hp = 30
	stats.hp = 30
	stats.attack = 8
	stats.defense = 4
	stats.speed = 6
