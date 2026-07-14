extends Node2D

@onready var menu_labels = [
	$Menu/Attack,
	$Menu/Item,
	$Menu/Run,
]

@onready var hp_label = $HPLabel

var player_turn := true

@onready var enemy_hp_label = $EnemyHPLabel

var selected := 0

func _ready():
	update_menu()
	update_hp()
	update_enemy_hp()

func _unhandled_input(event):
	
	if !player_turn:
		return
	
	if Input.is_action_just_pressed("move_down"):
		selected = (selected + 1) % menu_labels.size()
		update_menu()

	elif Input.is_action_just_pressed("move_up"):
		selected = (selected - 1 + menu_labels.size()) % menu_labels.size()
		update_menu()

	elif Input.is_action_just_pressed("interact"):
		choose_option()

func update_menu():
	var names = [
		"Attack",
		"Item",
        "Run"
	]

	for i in menu_labels.size():
		menu_labels[i].text = ("> " if i == selected else "  ") + names[i]

func choose_option():
	match selected:
		0:
			player_turn = false
			attack_enemy()
		1:
			print("Item")
		2:
			print("Run")

func update_hp():
	hp_label.text = "HP: %d/%d" % [
		PlayerStats.stats.hp,
		PlayerStats.stats.max_hp
	]

func update_enemy_hp():
	enemy_hp_label.text = "Enemy HP: %d/%d" % [
		BattleManager.enemy_stats.hp,
		BattleManager.enemy_stats.max_hp
	]

func attack_enemy():
	var player = PlayerStats.stats
	var enemy = BattleManager.enemy_stats

	var damage = max(player.attack - enemy.defense, 1)

	enemy.hp -= damage
	enemy.hp = max(enemy.hp, 0)

	update_enemy_hp()

	print("Dealt %d damage!" % damage)

	if enemy.hp <= 0:
		print("Enemy defeated!")
		BattleManager.end_battle()
		return

	await get_tree().create_timer(0.5).timeout
	enemy_attack()

func enemy_attack():
	var player = PlayerStats.stats
	var enemy = BattleManager.enemy_stats

	var damage = max(enemy.attack - player.defense, 1)

	player.hp -= damage
	player.hp = max(player.hp, 0)

	update_hp()

	print("Enemy dealt %d damage!" % damage)

	if player.hp <= 0:
		print("Player defeated!")
		BattleManager.end_battle()
		
	
	if player.hp > 0:
		player_turn = true
