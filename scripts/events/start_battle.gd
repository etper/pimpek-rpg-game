extends EventCommand
class_name StartBattleEvent

func execute(_context):
	BattleManager.start_battle()
