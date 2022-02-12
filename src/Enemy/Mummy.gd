extends KinematicBody2D

#movement variables
export var gravity = 3
export var speed = 40
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)

var direction = -1
var turnAround = false
#Enemy Viewport Activation Vars
var enemyInPlayerViewport = false

#Enemy HP/DMG variables
var mummyHitPoints = 100
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
		movement_TurnAround(true)
	elif is_on_wall() == false:
		movement_TurnAround(false)
		
func movement_TurnAround(turnAround):
	if turnAround == true and is_on_floor():
#		$AnimatedSprite.play("run")
#		$AnimatedSprite.flip_h = false
		direction = direction *-1
		pass
	elif turnAround == false and is_on_floor():
#		$AnimatedSprite.play("run")
#		$AnimatedSprite.flip_h = true
		pass

func _on_EnemyEntered_PlayerViewport():
	enemyInPlayerViewport = true

func getMummyHitpoints():
	return mummyHitPoints

func take_damage(dmgVal):
	if dmgVal >= 0:
		mummyHitPoints = getMummyHitpoints() - dmgVal
		setEnemyHealthbar(mummyHitPoints)
		velocity.y -= 100
		if mummyHitPoints <= 0:
			mummyIsDead()
		else:
			pass

func setEnemyHealthbar(mummyCurrentHitPoints):
	pass
func mummyIsDead():
	executeEnemyDespawn()
func executeEnemyDespawn():
	queue_free()
