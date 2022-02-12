extends KinematicBody2D

#movement variables
export var gravity = 3
export var speed = 30
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)
var acceleration = 5
var max_speed = 40
var jump = -85
var direction = 1
var turnAround = false
#Enemy Viewport Activation Vars
var enemyInPlayerVisibilityRange = false

#Enemy HP/DMG variables
var enemyHitPoints = 100
var damageValue = 25
var powerLevel = 1 

func _physics_process(delta):
	velocity.x = speed * direction
	velocity.y += gravity
	enemyInPlayerVisibilityRange = checkPlayerVisibilityRange()
	if enemyInPlayerVisibilityRange == true:		
		velocity = move_and_slide(velocity, FLOOR_NORMAL)	
		movementHandler()
	else:
		pass

func checkPlayerVisibilityRange():
	
	var checkEnemyInViewport = true
	return checkEnemyInViewport
	
func movementHandler():
	if is_on_wall() == true:
		direction = direction *-1
		turnAround = true
		movement_TurnAround(turnAround)
	else:
		turnAround = false
		movement_TurnAround(turnAround)
		
func movement_TurnAround(turnAround):
	if turnAround == true and is_on_floor():
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	if turnAround == false and is_on_floor():
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true

func _on_EnemyEntered_PlayerViewport():
	print("entered viewport")
