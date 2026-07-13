extends EventCommand
class_name WaitEvent

@export var seconds := 1.0

func execute(context):
	await context.get_tree().create_timer(seconds).timeout
