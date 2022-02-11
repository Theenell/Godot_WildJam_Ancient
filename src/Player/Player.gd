extends KinematicBody2D

export var  gravity = 10 
export var  speed = Vector2(100, 1000)
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0, -1)

var currentMovementDirection = ""

var teleport_possible = false
var teleport_impossible = false
var can_shoot = true
var can_teleport = true
var jumping = false
var animation_finished = false
var is_throwing = false
var shoot_enabled = true
var teleport_delay_finished = true

var playerHitPoints = 100
var mainAttackDamageValue = 10
var mainCharPwrLevel = 1

const weapon_flamethrower_flame = preload("res://src/Player/Abilities/Attack_Flamethrower.tscn")
const teleportprojektil = preload("res://src/Player/Teleportprojektil.tscn")

func _physics_process(_delta: float) -> void:
	physics()
	aim_and_shoot()
	if teleport_delay_finished == true:
		teleport()
	movementAnimation()
	attack_Weapon_Flamethrower()
	
#	attack_Flamethrower(getFlamethrowerFuel())

func physics():
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func getPlayerHitpoints():
	return playerHitPoints
	
func setPlayerHitpoints(dealOrReceive,relativeChangeValue):
	if dealOrReceive == "deal":
		playerHitPoints = playerHitPoints + relativeChangeValue
	elif dealOrReceive == "receive":
		playerHitPoints = playerHitPoints - relativeChangeValue
		
func playerDamageTaken(body,dmgVal):
	var previousHitpoints = getPlayerHitpoints()
	playerHitPoints = previousHitpoints - dmgVal
	if playerHitPoints <= 0:
		playerIsDead(body)

#RESPAWN AFTER DEATH
func playerIsDead(body):
	initiatePlayerRespawn(body)

func initiatePlayerRespawn(body):
	executePlayerDespawn()
	get_parent().respawnTimer(body,2)
	
func executePlayerDespawn():
	queue_free()

func attack_Weapon_Flamethrower():
	if Input.is_action_pressed("MainChar_Attack_Flamethrower"):
		var playerObj = get_parent().get_node("Player")
		var flameObj = playerObj.get_node("Attack_Flamethrower")
		var flameObjSprite = flameObj.get_node("AnimatedSprite")

		flameObj.setFlamethrowerFuel(250)
		
		var currentFuel = flameObj.getFlamethrowerFuel()
		if getCurrentMovementDirection() == "left":
			flameObjSprite.play("flame")
			flameObjSprite.visible = true
			flameObjSprite.position.x = playerObj.position.x +1000
		elif getCurrentMovementDirection() == "right":
			flameObjSprite.play("flame")
			flameObjSprite.visible = true
			flameObjSprite.position.x = playerObj.position.x -1000
		else:
			flameObjSprite.play("minorLiquidFuelSquirt")
			$AnimatedSprite.visible = false
					
					
#		if not playerObj == null:
#			playerObj.get_node(flameStr).destroy()
#		var wep_FT = weapon_flamethrower_flame.instance()
#		get_parent().add_child(wep_FT)
#		playerObj.add_child(wep_FT)
#		wep_FT.start(playerObj.get_state().get_node_property_value().position.x - 1000, getCurrentMovementDirection())
#		var flametrowerFuel = get_parent().get_node("Player").get_node("Flame").getFlamethrowerFuel()
		
#		for i in range(currentFuel,0):
##			rema = playerObj.get_node(flameStr).flamethrowerHeatingCooldown(remainingFuel,50)
#			if i <= 0:
#				playerObj.get_node(flameStr).destroy()
#			elif i >= 0:
		
#			i = i - 1
			
func _on_Area2D_body_entered(body):
	if body.name == "Enemy":
		velocity.y -= 150
		
#		if body.has_method("getEnemyHitpoints"):
#			var enemyHealth = body.getEnemyHitpoints()
#			if enemyHealth >= 1 && enemyHealth <= 200:
#				attack_MainWeapon(body)
#200 >> getDefaultenemyHealthFromEnemyScript LOL


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if Input.is_action_just_pressed("teleport") and is_on_floor() == false:
		if teleport_possible == true:
			direction.y = -1
			speed.y = 400
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	return velocity


			
func setCurrentMovementDirection(newDir):
	pass
func getCurrentMovementDirection():
	return currentMovementDirection
	
func movementAnimation():
	if Input.is_action_pressed("move_left") and is_on_floor():
		setCurrentMovementDirection("left")
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
#		if not $WalkingSound.is_playing():
#			$WalkingSound.play()
	elif Input.is_action_pressed("move_right") and is_on_floor():
		setCurrentMovementDirection("right")
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
#		if not $WalkingSound.is_playing():
#			$WalkingSound.play()
	elif Input.is_action_just_pressed("jump"):
		if is_on_floor() == false:
			jumping = true 
			$AnimatedSprite.play("jump")
			$WalkingSound.stop()
	elif is_on_floor() == false and jumping == false:
		$AnimatedSprite.play("falling")
		$WalkingSound.stop()
		if Input.is_action_pressed("move_left"):
			setCurrentMovementDirection("left")
			$AnimatedSprite.flip_h = true
		elif Input.is_action_pressed("move_right"):
			setCurrentMovementDirection("right")
			$AnimatedSprite.flip_h = false
	else:
		if is_on_floor():
			if is_throwing == false:
				$AnimatedSprite.play("idle")
				$WalkingSound.stop()
	setCurrentMovementDirection("")

func _on_AnimatedSprite_animation_finished():
	jumping = false
	is_throwing = false
	setCurrentMovementDirection("")

func _on_Timer_timeout():
	shoot_enabled = true

func _on_AnimatedEffect_animation_finished():
	$AnimatedEffect.stop()
	$AnimatedEffect.visible = false
	
func aim_and_shoot():
	$Aim_shape.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("teleportprojektil") and can_shoot == true:
		if shoot_enabled == true:
			$ShootTimer.start()
			shoot_enabled = false
			can_teleport = true
			can_shoot = false
			var dir = Vector2(1, 0).rotated($Aim_shape/Muzzle.global_rotation)
			var pos = $Aim_shape/Muzzle.global_position
			var p = teleportprojektil.instance()
			get_parent().add_child(p)
			p.start(pos, dir)
			

func teleport_possible():
	teleport_possible = true
	
func teleport_impossible():
	teleport_possible = false
	can_shoot = true
	
func teleport():
	if Input.is_action_just_pressed("teleportprojektil") and is_throwing == false:
			is_throwing = true
			$AnimatedSprite.play("throw")
	if Input.is_action_just_pressed("teleport") and teleport_possible == true:
		if can_teleport == true:
			teleport_delay_finished = false
			$TeleportDelay.start()
			var diskposition = get_parent().get_node("Teleportprojektil").position
			can_teleport = false
			get_parent().get_node("Teleportprojektil")._on_Timer_timeout()
			position = diskposition
			$AnimatedSprite.visible = false
			$AnimatedEffect.visible = true
			$AnimatedEffect.play("appear")
			$TeleportSound.play()
			

func _on_TeleportDelay_timeout():
	teleport_delay_finished = true
	$AnimatedSprite.visible = true
