extends Node2D

export var speed = 0
export var times_to_dash = 0
export (float) var screen_shake_amount = 0

var is_attacking = false
var times_left_to_dash = 0

func _process(_delta):
	if get_parent().phase == get_parent().phases.DEAD:
		$WallCollision/CollisionShape2D.disabled = true
		times_left_to_dash = 0

func dash():
	times_left_to_dash = times_to_dash
	if get_parent().get_node("Sprite").flip_h == true:
		get_parent().get_node("Scepter/Sprite").flip_h = true
		get_parent().get_node("Scepter").position = get_parent().get_node("Scepter").right_resting_position
		get_parent().velocity.x = speed
	if get_parent().get_node("Sprite").flip_h == false:
		get_parent().get_node("Scepter/Sprite").flip_h = false
		get_parent().get_node("Scepter").position = get_parent().get_node("Scepter").left_resting_position
		get_parent().velocity.x = -speed
	is_attacking = true
	times_left_to_dash -= 1
	get_parent().get_node("AnimationPlayer").play("Run")

func _on_WallCollision_body_entered(_body):
	if is_attacking == true:
		get_parent().get_node("ScreenShakeController").shake(screen_shake_amount)
		if times_left_to_dash > 0:
			if get_parent().velocity.x > 0:
				get_parent().get_node("Sprite").flip_h = false
				get_parent().get_node("Scepter/Sprite").flip_h = false
				get_parent().get_node("Scepter").position = get_parent().get_node("Scepter").left_resting_position
			if get_parent().velocity.x < 0:
				get_parent().get_node("Sprite").flip_h = true
				get_parent().get_node("Scepter/Sprite").flip_h = true
				get_parent().get_node("Scepter").position = get_parent().get_node("Scepter").right_resting_position
			get_parent().velocity.x *= -1
			times_left_to_dash -= 1
		else:
			get_parent().velocity.x = 0
			is_attacking = false
			if get_parent().get_node("Sprite").flip_h == true:
				get_parent().get_node("Sprite").flip_h = false
				get_parent().get_node("Scepter/Sprite").flip_h = false
				get_parent().get_node("Scepter").position = get_parent().get_node("Scepter").left_resting_position
			if get_parent().get_node("Sprite").flip_h == false:
				get_parent().get_node("Sprite").flip_h = true
				get_parent().get_node("Scepter/Sprite").flip_h = true
				get_parent().get_node("Scepter").position = get_parent().get_node("Scepter").right_resting_position
			get_parent().get_node("AnimationPlayer").play("Idle")
