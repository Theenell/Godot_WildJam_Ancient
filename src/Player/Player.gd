extends KinematicBody2D

export var gravity = 3
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)
var acceleration = 5
var max_speed = 60
var jump = -85
var axe_damage = 50
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
		$AnimationPlayer.play("axe_swing")
		print("axe_attack")
		$Axe/Axe_hitbox.disabled = false
		yield(get_tree().create_timer(1.0), "timeout")
		$Axe/Axe_hitbox.disabled = true
		
func aim_and_shoot():
	$Weapon.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):

			var dir = Vector2(1, 0).rotated($Weapon/Muzzle.global_rotation)
			var pos = $Weapon/Muzzle.global_position
			var p = projectile_1.instance()
			get_parent().add_child(p)
			p.start(pos, dir)


func _on_Axe_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(axe_damage)
