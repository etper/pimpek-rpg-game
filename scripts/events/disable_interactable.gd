extends EventCommand
class_name DisableInteractableEvent

func execute(context):
	if context:
		context.monitoring = false
		context.monitorable = false

		var shape: CollisionShape2D = context.get_node("InteractShape")
		if shape:
			shape.disabled = true
