extends Node

@export var player_data: PlayerData

var previous_scene_path := ""
var current_enemy: EnemyData

func start_battle(enemy: EnemyData):
	previous_scene_path = get_tree().current_scene.scene_file_path
	current_enemy = enemy
	call_deferred("_enter_battle")

func _enter_battle():
	get_tree().change_scene_to_file("res://battle/battle_scene.tscn")

func end_battle():
	get_tree().change_scene_to_file(previous_scene_path)
