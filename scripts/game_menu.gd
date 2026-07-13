extends CanvasLayer

var open := false

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("menu"):
		toggle()

func toggle():
	open = !open
	visible = open

	get_tree().paused = open

	if open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
