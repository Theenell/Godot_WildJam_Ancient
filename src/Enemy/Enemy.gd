extends KinematicBody2D
export var gravity = 10 
var FLOOR_NORMAL = Vector2(0,-1)
var velocity = Vector2()
var speed = 75

var direction = 1
var turnAround = false

var enemyHitPoints = 100
var damageValue = 25
var powerLevel = 1

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
		movement_TurnAround(turnAround)
		
func movement_TurnAround(turnAround):
	if turnAround == true and is_on_floor():
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	if turnAround == false and is_on_floor():
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
		
func _on_Area2D_body_entered(body):
#	if body.name == "Player":
#		if body.has_method("getPlayerHitpoints"):
#			var playerHealth = body.getPlayerHitpoints()
#			if playerHealth >= 1 && playerHealth <= 100:
#				dealDamageToPlayer(body)
	
	if body.name == "Attack_Flamethrower":
		if body.has_method("getPlayerHitpoints"):
			var playerHealth = body.getPlayerHitpoints()
			if playerHealth >= 1 && playerHealth <= 100:
				dealDamageToPlayer(body)

				
func dealDamageToPlayer(body):
	if body.name == "Player":
		var dmgVal = damageValue
		var pwrlvl = powerLevel
		body.playerDamageTaken(body,dmgVal*pwrlvl)

func getEnemyHitpoints():
	return enemyHitPoints

func enemyDamageTaken(body,dmgVal):
	var previousHitpoints = getEnemyHitpoints()
	enemyHitPoints = previousHitpoints - dmgVal
	if enemyHitPoints <= 0:
		enemyIsDead(body)
		
func enemyIsDead(body):
	initiateEnemyRespawn(body)

func initiateEnemyRespawn(body):
	executeEnemyDespawn()
	get_parent().respawnTimer(body,3)
	
func executeEnemyDespawn():
	queue_free()
