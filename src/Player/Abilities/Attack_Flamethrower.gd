extends KinematicBody2D
var velocity = Vector2.ZERO
var player = load("res://src/Player/Player.tscn")
var FT_FUEL = 250
var FT_minFUEL = 0
var FT_maxFUEL = 500
var FT_DMG_VAL = 50
var FT_DMG_POWERFACTOR = 1.0

func getFlamethrowerDamageValue():
	return FT_DMG_VAL * FT_DMG_POWERFACTOR
	
func setFlamethrowerDamageValue(val,factor):
	FT_DMG_VAL = val
	FT_DMG_POWERFACTOR = factor
	
func getFlamethrowerFuel():
	var fuel = FT_FUEL
	return fuel
	
func setFlamethrowerFuel(val):
	FT_FUEL = val
	
func attack_MainWeapon(body):
	if body.name == "Enemy":
		body.enemyDamageTaken(body,getFlamethrowerDamageValue())
	
#func flamethrowerHeatingCooldown(fuelVal,fuelDrainRate):
#	if (fuelVal >= FT_minFUEL && fuelVal <= FT_maxFUEL):
#		fuelVal = fuelVal-fuelDrainRate
#		setFlamethrowerFuel(fuelVal)
##		print(getFlamethrowerFuel())
		
		
#	$Timer.wait_time = respawnTime
#	$Timer.start()

#func _on_Timer_timeout():
#
func destroy():
	queue_free()
