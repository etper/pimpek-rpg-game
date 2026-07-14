extends Node

signal battle_started
signal battle_ended

var overworld_scene: Node = null
var battle_scene: Node = null
var in_battle := false

const BATTLE_SCENE = preload("res://scenes/battle.tscn")

func start_battle():
	if in_battle:
		return

	in_battle = true

	overworld_scene = get_tree().current_scene
	overworld_scene.process_mode = Node.PROCESS_MODE_DISABLED

	battle_scene = BATTLE_SCENE.instantiate()
	get_tree().root.add_child(battle_scene)

	battle_started.emit()

func end_battle():
	if !in_battle:
		return

	battle_scene.queue_free()
	battle_scene = null

	overworld_scene.process_mode = Node.PROCESS_MODE_INHERIT
	overworld_scene = null

	in_battle = false

	battle_ended.emit()
