extends Node2D

export var jump_height = 0
export (float) var time_in_air = 0
export var upward_speed = 0
export var downward_speed = 0
export var max_left_pos = 0
export var max_right_pos = 0
export (float) var land_shake_amount = 0

var target = Vector2(0, 0)
var has_hit_ground = true

func _process(_delta):
	if target != Vector2(0, 0):
		if get_parent().global_position.distance_to(target) <= 5:
			target = Vector2(0, 0)
			get_parent().velocity = Vector2(0, 0)
			$InAirTimer.start(time_in_air)

func jump():
	target = Vector2(0, 0)
	target = Vector2(get_tree().get_nodes_in_group("Player")[0].global_position.x, -jump_height)
	if target.x < max_left_pos:
		target.x = max_left_pos
	if target.x > max_right_pos:
		target.x = max_right_pos
	get_parent().velocity = global_position.direction_to(target) * upward_speed
	if get_parent().velocity.x > 0:
		get_parent().get_node("Sprite").flip_h = true
	if get_parent().velocity.x < 0:
		get_parent().get_node("Sprite").flip_h = false

func _on_InAirTimer_timeout():
	has_hit_ground = false
	get_parent().velocity = Vector2(0, 0)
	get_parent().velocity = Vector2(0, downward_speed)
	get_parent().get_node("AnimationPlayer").play("Idle")

func _on_GroundCollision_body_entered(_body):
	if has_hit_ground == false:
		has_hit_ground = true
		get_parent().get_node("ScreenShakeController").shake(land_shake_amount, 0.8)
