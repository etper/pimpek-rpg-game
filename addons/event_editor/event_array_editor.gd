@tool
extends EditorInspectorPlugin

const EventProperty = preload("res://addons/event_editor/event_property.gd")

func _can_handle(_object):
	return true

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):

	if name != "events":
		return false

	print("FOUND EVENTS PROPERTY")

	var property = EventProperty.new()
	property.setup(object, name)

	add_property_editor(name, property)

	return true
