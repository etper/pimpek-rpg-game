extends Panel

@onready var icon = $Hbox/Icon
@onready var text_label = $Hbox/Text

func setup(item_name: String, item_icon: Texture2D, amount: int, added: bool):
	text_label.text = "%s %s x%d" % [
		"Otrzymujesz:" if added else "Tracisz:",
		item_name,
		amount
	]

	icon.texture = item_icon

	position.x = -size.x

	var tween = create_tween()
	tween.tween_property(self, "position:x", 0, 0.25)

	await tween.finished
	await get_tree().create_timer(2.0).timeout

	tween = create_tween()
	tween.tween_property(self, "position:x", -size.x, 0.25)

	await tween.finished
	queue_free()
