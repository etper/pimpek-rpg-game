extends EventCommand
class_name ChoiceEvent

@export_multiline var question := ""
@export var choices: Array[DialogueChoice]

func execute(context):
	var ui = context.get_tree().current_scene.get_node("UI")

	var result = await ui.show_choice(question, choices)

	if result >= 0:
		await EventRunner.run(choices[result].events, context)
