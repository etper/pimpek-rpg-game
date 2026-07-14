extends Node

signal battle_started
signal battle_ended

var overworld_scene: Node = null
var battle_scene: Node = null
var in_battle := false

var enemy_data: EnemyData
var enemy_stats: CharacterStats

const BATTLE_SCENE = preload("res://scenes/battle.tscn")

enum BattleResult {
	WIN,
	LOSE,
	RUN
}

var last_result := BattleResult.WIN

func start_battle(enemy: EnemyData):
	if in_battle:
		return

	enemy_data = enemy
	enemy_stats = enemy.stats.duplicate(true)

	in_battle = true

	overworld_scene = get_tree().current_scene
	overworld_scene.process_mode = Node.PROCESS_MODE_DISABLED

	battle_scene = BATTLE_SCENE.instantiate()
	get_tree().root.add_child(battle_scene)

	battle_started.emit()

func end_battle(result := BattleResult.WIN):
	if !in_battle:
		return

	last_result = result

	battle_scene.queue_free()
	battle_scene = null

	overworld_scene.process_mode = Node.PROCESS_MODE_INHERIT
	overworld_scene = null

	in_battle = false

	battle_ended.emit()
