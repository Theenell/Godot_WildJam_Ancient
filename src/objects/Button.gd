extends StaticBody2D

var player_on_button = false

func _physics_process(delta):
	interact()
	
func interact():
	if player_on_button == true and Input.is_action_just_pressed("Button"):
		if $Red_Button.visible == true:
			$Red_Button.visible = false
			$Green_Button.visible = true
			
		elif $Green_Button.visible == true:
			$Red_Button.visible = true
			$Green_Button.visible = false

func _on_Area2D_body_entered(body):
	player_on_button = true
