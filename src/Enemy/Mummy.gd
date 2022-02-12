extends KinematicBody2D

#movement variables
export var gravity = 3
export var speed = 40
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)

var direction = 1
var turnAround = false
#Enemy Viewport Activation Vars
var enemyInPlayerViewport = false

#Enemy HP/DMG variables
var enemyHitPoints = 100
var damageValue = 25
var powerLevel = 1 

func _physics_process(_delta):
	velocity.x = speed * direction
	velocity.y += gravity
	enemyInPlayerViewport = getVarEnemyInPlayerViewport()
	if enemyInPlayerViewport == true:		
		velocity = move_and_slide(velocity, FLOOR_NORMAL)	
		movementHandler()
	else:
		pass

func getVarEnemyInPlayerViewport():
	return enemyInPlayerViewport
	
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
#		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	if turnAround == false and is_on_floor():
#		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true

func _on_EnemyEntered_PlayerViewport():
	enemyInPlayerViewport = true
	print ("eInVp")
