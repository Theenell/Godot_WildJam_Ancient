extends KinematicBody2D

export var gravity = 3
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)
var acceleration = 5
var max_speed = 40
var jump = -85



func _physics_process(delta: float) -> void:
	
	var friction = false
	velocity.y += gravity
	
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, max_speed)

	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -max_speed)

	else:
		friction = true

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2) #farten minskar 20% varje frame

	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.4)

			
		

			
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
