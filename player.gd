extends CharacterBody2D

@export var speed := 200.0

@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	velocity = direction * speed
	move_and_slide()

	if direction == Vector2.ZERO:
		if anim.animation.begins_with("walk"):
			anim.play(anim.animation.replace("walk", "idle"))
		return

	if abs(direction.x) > abs(direction.y):
		anim.flip_h = direction.x < 0
		anim.play("walk_side")
	elif direction.y > 0:
		anim.flip_h = false
		anim.play("walk_down")
	else:
		anim.flip_h = false
		anim.play("walk_up")
