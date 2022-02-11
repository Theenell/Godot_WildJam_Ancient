extends Node
const player = preload("res://src/Player/Player.tscn")
const enemy = preload("res://src/Enemy/Enemy.tscn")
var callerNodeName = ""
var respawnTime = 1.0
var playerRespawnStatus = true
var enemyRespawnStatus = true

func _physics_process(delta):
	debugHotkeys()
	
func debugHotkeys():
	#KillPlayer
	if Input.is_action_pressed("killPlayer"):
		get_node("Player").playerIsDead()

func setCallerNodeName(nodeName):
	callerNodeName = nodeName
	
func respawnTimer(body,customRespawnTime):
	setCallerNodeName(body.name)
	if customRespawnTime >= 0:
		respawnTime = customRespawnTime
	$Timer.wait_time = respawnTime
	$Timer.start()

func _on_Timer_timeout():
	executeRespawn(callerNodeName)
		
func executeRespawn(nodeName):
	if nodeName == "Player":
		getPlayerRespawnStatus()
		if playerRespawnStatus == true:
			var playerNode = player.instance()
			add_child(playerNode)
			playerNode.position.x = 1
			setPlayerRespawnStatus(false)
	elif nodeName == "Enemy":
		getEnemyRespawnStatus()
		if enemyRespawnStatus == true:
			var enemyNode = enemy.instance()
			add_child(enemyNode)
			enemyNode.position.x = 1
			setEnemyRespawnStatus(false)
	
func setPlayerRespawnStatus(newPlayerRespawnStatus):
	playerRespawnStatus = newPlayerRespawnStatus
	getPlayerRespawnStatus()
	
func getPlayerRespawnStatus():
	return playerRespawnStatus
	
func setEnemyRespawnStatus(newEnemyRespawnStatus):
	enemyRespawnStatus = newEnemyRespawnStatus
	getEnemyRespawnStatus()
	
func getEnemyRespawnStatus():
	return enemyRespawnStatus
	
func getCharacterHitpoints(charName):
	var hitPoints = 0
	if charName == "Enemy":
		hitPoints = get_node("Enemy").getEnemyHitpoints()
		return hitPoints
	elif charName == "Player":
		hitPoints = get_node("Player").getPlayerHitpoints()
		return hitPoints
