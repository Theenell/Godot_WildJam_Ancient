extends KinematicBody2D
var generalClassLib = preload("res://src/GeneralClassLib.gd").new()
export var gravity = 3
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2(0,-1)
var acceleration = 5
var max_speed = 100
var jump_force = -120
var axe_damage = 50
const projectile_1 = preload("res://src/Player/projectiles/projectile_1.tscn")
const projectile_2 = preload("res://src/Player/projectiles/Projectile_2.tscn")
var health = 100

var recoil_puchback_direction = Vector2()
var recoil = false
var current_weapon = 1
var wall_jump_counter = 0
var on_wall = false
var can_wall_jump = true

func _physics_process(delta: float) -> void:
	var friction = false
	velocity.y += gravity
	
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, max_speed)

	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -max_speed)

	else:
		friction = true

	if is_on_floor() and on_wall == false:
		can_wall_jump = true
		wall_jump_counter = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_force
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2) #farten minskar 20% varje frame
			
			

	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.4)
	if recoil == false:
		velocity = move_and_slide(velocity, FLOOR_NORMAL)
	else:
		velocity = move_and_slide(velocity+recoil_puchback_direction, FLOOR_NORMAL)
	
	pickaxe_attack()
	aim_and_shoot()
	wall_check()
	wall_jump()
	choose_weapon()
	
func wall_check():
	if $RayCast_Left.is_colliding() or $RayCast_Right.is_colliding():
		on_wall = true
	else:
		on_wall = false
func wall_jump():
	if on_wall == true:
		if can_wall_jump == true:
			if Input.is_action_just_pressed("jump"):
				wall_jump_counter += 1
				print(wall_jump_counter)
				velocity.y += -180
				if wall_jump_counter >= 3:
					can_wall_jump = false 
#				can_wall_jump = false
#				$Wall_jump_timer.start()
func pickaxe_attack():
	if Input.is_action_just_pressed("axe_attack"):
		$AnimationPlayer.play("axe_swing")
		print("axe_attack")
		$Axe/Axe_hitbox.disabled = false
		yield(get_tree().create_timer(1.0), "timeout")
		$Axe/Axe_hitbox.disabled = true
func choose_weapon():
	if Input.is_action_just_pressed("weapon_1"):
		current_weapon = 1
		$Weapon_1.visible = true
		$Weapon_2.visible = false
	if Input.is_action_just_pressed("weapon_2"):
		current_weapon = 2
		$Weapon_1.visible = false
		$Weapon_2.visible = true
func recoil():
	if recoil == true:
		$Recoil_Timer.start()
		recoil_puchback_direction = (global_position - get_global_mouse_position()).normalized() * 25
		

func aim_and_shoot():
	$Weapon_1.look_at(get_global_mouse_position())
	$Weapon_2.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		if current_weapon == 1:
			var dir = Vector2(1, 0).rotated($Weapon_1/Muzzle.global_rotation)
			var pos = $Weapon_1/Muzzle.global_position
			var p = projectile_1.instance()
			get_parent().add_child(p)
			p.start(pos, dir)
		if current_weapon == 2:
			
			$Camera2D/ScreenShake.start()
			recoil = true
			recoil()
			var dir_1 = Vector2(1, 0).rotated($Weapon_2/Muzzle_1.global_rotation)
			var dir_2 = Vector2(1, 0).rotated($Weapon_2/Muzzle_2.global_rotation)
			var dir_3 = Vector2(1, 0).rotated($Weapon_2/Muzzle_3.global_rotation)
			var dir_4 = Vector2(1, 0).rotated($Weapon_2/Muzzle_4.global_rotation)
		
			var pos_1= $Weapon_2/Muzzle_1.global_position
			var pos_2= $Weapon_2/Muzzle_2.global_position
			var pos_3= $Weapon_2/Muzzle_3.global_position
			var pos_4= $Weapon_2/Muzzle_4.global_position
			
			var p1 = projectile_1.instance()
			var p2 = projectile_1.instance()
			var p3 = projectile_1.instance()
			var p4 = projectile_1.instance()
			
			get_parent().add_child(p1)
			get_parent().add_child(p2)
			get_parent().add_child(p3)
			get_parent().add_child(p4)
			
			p1.start(pos_1, dir_1)
			p2.start(pos_2, dir_2)
			p3.start(pos_3, dir_3)
			p4.start(pos_4, dir_4)

func take_dagamage(damage):
	health -= 100 
	if health <= 0:
		player_dead()

func player_dead():
	pass
		
func _on_Axe_body_entered(body):
	generalClassLib.take_damage(body,axe_damage)

func _on_Wall_jump_timer_timeout():
	can_wall_jump = true


func _on_Recoil_Timer_timeout():
	recoil = false
	print("sdf")
