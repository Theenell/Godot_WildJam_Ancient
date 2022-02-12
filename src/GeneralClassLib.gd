class_name GeneralClassLib
extends KinematicBody2D

#var playerScript = preload("res://src/Player/Player.gd")

var callerNodeBodyName = ""
#general kinematic nodes properties
#export var gravity = 3

func getCallerNodeBodyName(body):
	callerNodeBodyName = body.name
	return callerNodeBodyName
	
func take_damage(body,dmgVal):
	getCallerNodeBodyName(body)
	
	if body.is_in_group("enemies"):
		if callerNodeBodyName == "Mummy":
			if dmgVal >= 0:
#				var mummyHitPoints = .getMummyHitpoints() - dmgVal
				var mummyHitPoints = body.getMummyHitpoints() - dmgVal
				print(mummyHitPoints)
				body.setMummyHitpoints(mummyHitPoints)
				body.setEnemyHealthbar(mummyHitPoints)
				body.velocity.y -= 50
				body.velocity.x -= 50
				if mummyHitPoints <= 0:
					body.mummyIsDead()
			else:
				pass
