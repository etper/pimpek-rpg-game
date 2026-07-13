extends EventCommand
class_name RemoveInteractableEvent

func execute(context):
	if context:
		context.queue_free()
