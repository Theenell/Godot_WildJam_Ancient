extends GeneralClassLib

#kinematicbody properties
export var gravity = 3
export var speed = 40
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)

#movement variables
var direction 
var turnAround = false

#Enemy Viewport Activation Vars
var enemyInPlayerViewport = false

#Enemy HP/DMG variables
var mummyHitPoints = 100
var damageValue = 25
var powerLevel = 1 

func _physics_process(_delta):
	
	player_position()
	velocity.x = speed * direction
	velocity.y += gravity


	if enemyInPlayerViewport == true:		
		velocity = move_and_slide(velocity, FLOOR_NORMAL)	
		movementHandler()
	else:
		pass
	
	

func player_position():
	if get_parent().get_node("Player").global_position.x <= global_position.x:
		direction = -1
	else:
		direction = 1
	velocity.x = speed * direction
	velocity.y += gravity
	
func movementHandler():
	if is_on_wall() == true:
		movement_TurnAround(true)
	elif is_on_wall() == false:
		movement_TurnAround(false)	

func movement_TurnAround(turnAround):
	#turning left
	if turnAround == true and is_on_floor():
#		$AnimatedSprite.play("run")
#		$AnimatedSprite.flip_h = false
		direction = direction *-1
		turnAround = false
	#turning right
	elif turnAround == false and is_on_floor():
#		$AnimatedSprite.play("run")
#		$AnimatedSprite.flip_h = true
		pass


func getMummyHitpoints():
	return mummyHitPoints

func setMummyHitpoints(newHitpoints):
	mummyHitPoints = newHitpoints
	
#func take_damage(dmgVal):
#	if dmgVal >= 0:
#		mummyHitPoints = getMummyHitpoints() - dmgVal
#		setEnemyHealthbar(mummyHitPoints)
#		velocity.y -= 50
#		velocity.x -= 50
#		if mummyHitPoints <= 0:
#			mummyIsDead()
#		else:
#			pass
func setEnemyHealthbar(mummyCurrentHitPoints):
	pass
func mummyIsDead():
	executeEnemyDespawn()
func executeEnemyDespawn():
	queue_free()
	
	
func _on_EnemyEntered_PlayerViewport():
	enemyInPlayerViewport = true
