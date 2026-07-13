extends Control

@onready var enemy_sprite = $Enemy
@onready var enemy_name = $UI/EnemyName
@onready var hp_label = $UI/HPLabel

var player: Battler
var enemy: Battler

enum BattleState {
	PLAYER_TURN,
	ENEMY_TURN,
	VICTORY,
	DEFEAT
}

var player_data: PlayerData = preload("res://battle/resources/player.tres")

var state = BattleState.PLAYER_TURN

func _ready():
	var enemy_data = BattleManager.current_enemy

	print(player)
	print(BattleManager.player_data)

	# Create player
	var data = BattleManager.player_data

	player = Battler.new()
	player.name = data.name
	player.max_hp = data.max_hp
	player.hp = data.max_hp
	player.attack = data.attack
	player.defense = data.defense

	# Create enemy
	enemy = Battler.new()
	enemy.name = enemy_data.name
	enemy.max_hp = enemy_data.max_hp
	enemy.hp = enemy.max_hp
	enemy.attack = enemy_data.attack
	enemy.defense = enemy_data.defense

	# Update visuals
	enemy_sprite.texture = enemy_data.sprite
	enemy_name.text = enemy.name

	update_player_hp()
	update_hp()

	$UI/VBoxContainer/AttackButton.pressed.connect(_on_attack_button_pressed)

func update_hp():
	hp_label.text = "HP: %d / %d" % [enemy.hp, enemy.max_hp]

func _on_attack_button_pressed() -> void:
	
	if state != BattleState.PLAYER_TURN:
		return
	
	player.attack_target(enemy)

	if enemy.hp < 0:
		enemy.hp = 0

	update_hp()

	if enemy.is_dead():
		victory()
		return

	state = BattleState.ENEMY_TURN
	enemy_turn()

func victory():
	state = BattleState.VICTORY
	print("Victory!")
	await get_tree().create_timer(1.5).timeout
	BattleManager.end_battle()

func update_player_hp():
	$UI/PlayerHPLabel.text = "Player HP: %d / %d" % [player.hp, player.max_hp]

func enemy_turn():
	player.take_damage(enemy.attack)

	if player.hp < 0:
		player.hp = 0

	update_player_hp()

	if player.hp > 0:
		state = BattleState.PLAYER_TURN

	if player.is_dead():
		defeat()

func defeat():
	state = BattleState.DEFEAT
	print("Defeat!")
	await get_tree().create_timer(1.5).timeout
	BattleManager.end_battle()
