extends EventCommand
class_name DialogueEvent

@export_multiline var text := ""

func execute(context):
	var tree = context.get_tree()
	var ui = tree.current_scene.get_node("UI")

	ui.show_dialogue(text)

	while ui.box.visible:
		await tree.process_frame
