extends Node2D

@onready var menu_labels = [
	$Menu/Attack,
	$Menu/Item,
	$Menu/Run,
]

enum BattleState {
	MENU,
	ITEM_MENU
}

var state = BattleState.MENU
var item_index = 0

@onready var hp_label = $HPLabel

var player_turn := true

@onready var enemy_hp_label = $EnemyHPLabel

var selected := 0

@onready var item_menu = $ItemMenu

@onready var item_labels = [
	$ItemMenu/Item0,
	$ItemMenu/Item1,
	$ItemMenu/Item2,
	$ItemMenu/Item3,
]

var item_ids = []
var item_selected = 0

func _ready():
	update_menu()
	update_hp()
	update_enemy_hp()

func _unhandled_input(event):

	if !player_turn:
		return

	match state:
		BattleState.MENU:
			if Input.is_action_just_pressed("move_down"):
				selected = (selected + 1) % menu_labels.size()
				update_menu()

			elif Input.is_action_just_pressed("move_up"):
				selected = (selected - 1 + menu_labels.size()) % menu_labels.size()
				update_menu()

			elif Input.is_action_just_pressed("interact"):
				choose_option()

		BattleState.ITEM_MENU:
			if Input.is_action_just_pressed("move_down"):
				item_selected = (item_selected + 1) % item_ids.size()
				update_item_menu()

			elif Input.is_action_just_pressed("move_up"):
				item_selected = (item_selected - 1 + item_ids.size()) % item_ids.size()
				update_item_menu()

			elif Input.is_action_just_pressed("interact"):
				choose_item()

			elif Input.is_action_just_pressed("cancel"):
				$ItemMenu.hide()
				$Menu.show()
				state = BattleState.MENU

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
			item_selected = 0
			update_item_menu()

			$Menu.hide()
			$ItemMenu.show()

			state = BattleState.ITEM_MENU
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
		print("Victory!")
		# TODO: give rewards

		BattleManager.end_battle(BattleManager.BattleResult.WIN)
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
		print("Game Over")

		BattleManager.end_battle(BattleManager.BattleResult.LOSE)
		
	
	if player.hp > 0:
		player_turn = true

func update_item_menu():
	item_ids = Inventory.items.keys()

	for i in item_labels.size():
		if i < item_ids.size():
			var id = item_ids[i]
			item_labels[i].text = (
				"> " if i == item_selected else "  "
			) + "%s x%d" % [
				id.capitalize(),
				Inventory.items[id]
			]
			item_labels[i].show()
		else:
			item_labels[i].hide()

func choose_item():
	if item_ids.is_empty():
		return

	var id = item_ids[item_selected]

	match id:
		"potion":
			if PlayerStats.stats.hp >= PlayerStats.stats.max_hp:
				print("HP is already full!")
				return

			PlayerStats.stats.hp = min(
				PlayerStats.stats.hp + 10,
				PlayerStats.stats.max_hp
			)

			Inventory.remove_item("potion", 1)

			update_hp()

			$ItemMenu.hide()
			$Menu.show()
			state = BattleState.MENU

			player_turn = false
			await get_tree().create_timer(0.5).timeout
			enemy_attack()
