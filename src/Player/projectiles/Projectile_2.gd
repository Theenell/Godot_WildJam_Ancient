extends KinematicBody2D
var generalClassLib = load("res://src/GeneralClassLib.gd").new()

var velocity = Vector2.ZERO
var speed = 300
var damage = 30 
var gravity = 5



func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed 
	
func _physics_process(delta):
	velocity.y += gravity 
	move_and_collide(velocity * delta)
