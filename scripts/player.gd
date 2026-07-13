extends CharacterBody2D

@export var speed := 200.0

var facing := Vector2.DOWN

@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

func _physics_process(_delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if direction != Vector2.ZERO:
		facing = direction.normalized()

	velocity = direction * speed
	move_and_slide()

	# Move interaction area in front of player
	interaction_area.position = facing * 24

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

	# Interact
	if Input.is_action_just_pressed("interact"):
		interact()

func interact():
	for area in interaction_area.get_overlapping_areas():
		if area.has_method("interact"):
			area.interact()
			return

	for body in interaction_area.get_overlapping_bodies():
		if body.has_method("interact"):
			body.interact()
			return
