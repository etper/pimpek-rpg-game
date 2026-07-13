extends EventCommand
class_name DialogueEvent

@export_multiline var text := ""

func execute(_context):
	var ui = get_tree().current_scene.get_node("UI")

	ui.show_dialogue(text)

	while ui.box.visible:
		await get_tree().process_frame
