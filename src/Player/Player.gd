extends KinematicBody2D

export var gravity = 3
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)
var acceleration = 5
var max_speed = 40
var jump = -85

const projectile_1 = preload("res://src/Player/projectiles/projectile_1.tscn")


func _physics_process(delta: float) -> void:
	
	var friction = false
	velocity.y += gravity
	
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, max_speed)

	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -max_speed)

	else:
		friction = true

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2) #farten minskar 20% varje frame

	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.4)

	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	pickaxe_attack()
	aim_and_shoot()
	
func pickaxe_attack():
	if Input.is_action_just_pressed("axe_attack"):
		print("axe_attack")
		$Axe_hitbox.disabled = false
		yield(get_tree().create_timer(1.0), "timeout")
		$Axe_hitbox.disabled = true
func aim_and_shoot():
	$Muzzle.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):

			var dir = Vector2(1, 0).rotated($Muzzle.global_rotation)
			var pos = $Muzzle.global_position
			var p = projectile_1.instance()
			get_parent().add_child(p)
			p.start(pos, dir)
