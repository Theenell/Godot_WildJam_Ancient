extends KinematicBody2D


var velocity = Vector2.ZERO
var speed = 200
var damage = 30 
var gravity = 1







func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed 
	
func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_collide(velocity * delta)



func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
	else:
		queue_free()

