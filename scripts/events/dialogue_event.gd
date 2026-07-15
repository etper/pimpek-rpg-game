extends EventCommand
class_name DialogueEvent

@export_multiline var text := ""
@export var expression: Texture2D

func execute(context):
	var tree = context.get_tree()
	var ui = tree.current_scene.get_node("UI")

	ui.show_dialogue(text, expression)

	while ui.box.visible:
		if ui.finished and Input.is_action_just_pressed("interact"):
			SoundManager.play_interact()
			ui.hide_dialogue()

		await tree.process_frame

func get_display_name() -> String:
	return "Dialogue"
