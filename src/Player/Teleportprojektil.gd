extends KinematicBody2D
var velocity = Vector2.ZERO
export var speed = 500
var player = load("res://src/Player/Player.tscn")

func start(_position, _direction):
	$Timer.wait_time = 2
	$Timer.start()
	get_parent().get_node("Player").teleport_possible()
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		rotation = velocity.angle()
	$AnimatedSprite.play("ice_ball")

func destroy():
	queue_free()
	
func _on_Timer_timeout():
	get_parent().get_node("Player").teleport_impossible()
	queue_free()
