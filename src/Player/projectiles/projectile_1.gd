extends KinematicBody2D


var velocity = Vector2.ZERO
var speed = 100







func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	
func _physics_process(delta):
	move_and_collide(velocity * delta)
