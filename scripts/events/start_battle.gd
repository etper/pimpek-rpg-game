extends EventCommand
class_name StartBattleEvent

@export var enemy: EnemyData

func execute(_context):
	BattleManager.start_battle(enemy)
