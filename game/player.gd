extends CharacterBody2D

@export var speed := 200
@export var jumpForce := 400
@export var gravity := 900

var vel := Vector2.ZERO

func _physics_process(delta):
	# gravitace
	if not is_on_floor():
		vel.y += gravity * delta
	else:
		vel.y = max(vel.y, 0)

	# horizontální pohyb
	var direction = Input.get_axis("move_left", "move_right")
	vel.x = direction * speed

	# skok
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = -jumpForce

	# zrušení skoku při nárazu do stropu
	if $CeilingCheck.is_colliding() and vel.y < 0:
		vel.y = 0

	# aplikuj pohyb
	move_and_slide()
