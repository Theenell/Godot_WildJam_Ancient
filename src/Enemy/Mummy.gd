extends KinematicBody2D
export var gravity = 3
export var speed = 30

var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)
var acceleration = 5
var max_speed = 40
var jump = -85
var direction = 1
var turnAround = false

func _physics_process(delta):
	velocity.x = speed * direction
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	movementHandler()
	
func movementHandler():
	if is_on_wall() == true:
		direction = direction *-1
		movement_TurnAround(turnAround)
	else:
		turnAround = false
		movement_turnAround(turnAround)
		
func movement_TurnAround(turnAround):
	if turnAround == true and is_on_floor():
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	if turnAround == false and is_on_floor():
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
