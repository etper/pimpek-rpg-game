extends CharacterBody2D

@export var walk_speed := 200.0
@export var sprint_multiplier := 1.8

var facing := Vector2.DOWN
var highlighted: Area2D = null

@onready var anim = $AnimatedSprite2D
@onready var interaction_shape = $InteractionArea

@export var down_offset := Vector2(0, 74)
@export var up_offset := Vector2(0, -64)
@export var left_offset := Vector2(-24, 0)
@export var right_offset := Vector2(24, 0)

func _physics_process(_delta):
	var ui = get_tree().current_scene.get_node("UI")

	# Prevent movement while an event sequence is running
	if EventRunner.busy:
		velocity = Vector2.ZERO
		move_and_slide()

		if ui.box.visible and Input.is_action_just_pressed("interact"):
			ui.hide_dialogue()

		return

	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if direction != Vector2.ZERO:
		facing = direction.normalized()

	var current_speed = walk_speed
	if Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier

	velocity = direction * current_speed
	move_and_slide()

	# Move interaction area in front of player
	update_interaction_position()

	# Speed up animations while sprinting
	anim.speed_scale = sprint_multiplier if Input.is_action_pressed("sprint") else 1.0

	# Animations
	if direction == Vector2.ZERO:
		if anim.animation == "walk_down":
			anim.flip_h = false
			anim.play("idle_down")
		elif anim.animation == "walk_up":
			anim.flip_h = false
			anim.play("idle_up")
		elif anim.animation == "walk_side":
			anim.play("idle_side")
	else:
		if abs(direction.x) > abs(direction.y):
			anim.flip_h = direction.x < 0
			anim.play("walk_side")
		elif direction.y > 0:
			anim.flip_h = false
			anim.play("walk_down")
		else:
			anim.flip_h = false
			anim.play("walk_up")

	update_highlight()

	if Input.is_action_just_pressed("interact"):
		interact()

func update_highlight():
	var target = null

	for area in interaction_shape.get_overlapping_areas():
		if area.has_method("interact"):
			target = area
			break

	if target == highlighted:
		return

	if highlighted:
		highlighted.set_highlight(false)

	highlighted = target

	if highlighted:
		highlighted.set_highlight(true)

func interact():
	velocity = Vector2.ZERO

	match anim.animation:
		"walk_down":
			anim.play("idle_down")
		"walk_up":
			anim.play("idle_up")
		"walk_side":
			anim.play("idle_side")

	for area in interaction_shape.get_overlapping_areas():
		if area.has_method("interact"):
			await area.interact()
			return

	for area in interaction_shape.get_overlapping_areas():
		if area == interaction_shape:
			continue

		if area.has_method("interact"):
			await area.interact()
			return

	for body in interaction_shape.get_overlapping_bodies():
		if body == self:
			continue

		if body.has_method("interact"):
			await body.interact()
			return

func update_interaction_position():
	if abs(facing.x) > abs(facing.y):
		interaction_shape.position = right_offset if facing.x > 0 else left_offset
	else:
		interaction_shape.position = down_offset if facing.y > 0 else up_offset
