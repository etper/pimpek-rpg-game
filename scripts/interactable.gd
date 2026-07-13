extends Area2D

@export_multiline var text := "Hello!"

func interact():
	get_tree().current_scene.get_node("UI").show_dialogue(text)
