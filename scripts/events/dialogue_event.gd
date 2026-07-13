extends EventCommand
class_name DialogueEvent

@export_multiline var text := ""

func execute(context):
	var tree = context.get_tree()
	var ui = tree.current_scene.get_node("UI")

	ui.show_dialogue(text)

	while ui.box.visible:
		if ui.finished and Input.is_action_just_pressed("interact"):
			ui.hide_dialogue()

		await tree.process_frame
