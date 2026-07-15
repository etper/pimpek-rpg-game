extends Panel

@onready var icon = $Hbox/Icon
@onready var text_label = $Hbox/Text

func setup(item_name: String, item_icon: Texture2D, amount: int, added: bool):
	text_label.text = "%s %s x%d" % [
		" Otrzymujesz:" if added else " Tracisz:",
		item_name,
		amount
	]

	icon.texture = item_icon

	# SFX
	if added:
		SoundManager.play_ding() # or play_item_get()
	else:
		SoundManager.play_remove() # or play_item_remove()

	scale = Vector2(0.9, 0.9)
	modulate.a = 0.0
	position.x = -size.x

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "position:x", 0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2.ONE, 0.22)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 1.0, 0.15)

	await tween.finished
	await get_tree().create_timer(2.0).timeout

	tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "position:x", -size.x, 0.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)

	tween.tween_property(self, "modulate:a", 0.0, 0.2)

	await tween.finished
	queue_free()
