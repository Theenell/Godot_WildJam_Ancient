extends KinematicBody2D
var generalClassLib = load("res://src/GeneralClassLib.gd").new()

var velocity = Vector2.ZERO
var speed = 100
var damage = 30 


func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	
func _physics_process(delta):
	move_and_collide(velocity * delta)


#func _on_Area2D_body_entered(body):
#	if body.is_in_group("enemy"):
#		if body.has_method("take_damage"):
#			body.take_damage(damage)
#			queue_free()
func _on_Area2D_body_entered(body):
	if not body.name == "projectile_1":
		generalClassLib.take_damage(body,damage)
