extends KinematicBody2D

export var throw_speed = 0
export var wall_collision_wait_time = 0
export var left_resting_position = Vector2(0, 0)
export var right_resting_position = Vector2(0, 0)

var velocity = Vector2(0, 0)
var throw_attack = false
var throw_wall_collision = false
var throw_boss_collision = false
var throw_direction = 0
var swing_attack = false

func _process(_delta):
	if swing_attack == false and throw_attack == false:
		if get_parent().phase == get_parent().phases.PHASE1 or get_parent().phase == get_parent().phases.PHASE2:
			if get_parent().get_node("Sprite").flip_h == true:
				position = right_resting_position
				$Sprite.flip_h = true
			else:
				position = left_resting_position
				$Sprite.flip_h = false

func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func swing():
	swing_attack = true
	if global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x < 0:
		$SwingAttack.play("SwingRight")
	else:
		$SwingAttack.play("SwingLeft")

func end_swing_attack():
	swing_attack = false

func throw():
	throw_attack = true
	throw_wall_collision = true
	if global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x < 0:
		get_parent().get_node("Sprite").flip_h = true
		position = right_resting_position
		$Sprite.flip_h = true
		throw_direction = 1
		$ThrowAttackTelegraph.play("ThrowRight")
	else:
		get_parent().get_node("Sprite").flip_h = false
		position = left_resting_position
		$Sprite.flip_h = false
		throw_direction = -1
		$ThrowAttackTelegraph.play("ThrowLeft")

func accelerate_left():
	velocity = Vector2(-throw_speed, 0)

func accelerate_right():
	velocity = Vector2(throw_speed, 0)

func _on_WallCollision_body_entered(_body):
	if throw_attack == true and throw_wall_collision == true:
		velocity = Vector2(0, 0)
		$WallCollisionTimer.start(wall_collision_wait_time)
		throw_wall_collision = false
		throw_boss_collision = true

func _on_BossCollision_body_entered(body):
	if throw_attack == true and throw_boss_collision == true:
		throw_attack = false
		throw_boss_collision = false
		throw_direction = 0
		if throw_direction == -1:
			get_parent().get_node("Sprite").flip_h = false
			position = left_resting_position
		if throw_direction == 1:
			get_parent().get_node("Sprite").flip_h = true
			position = right_resting_position
		velocity = Vector2(0, 0)
		global_position = body.global_position
		rotation = 0

func _on_WallCollisionTimer_timeout():
	if throw_direction == 1:
		$Sprite.flip_h = false
		velocity = Vector2(-throw_speed, 0)
	if throw_direction == -1:
		$Sprite.flip_h = true
		velocity = Vector2(throw_speed, 0)
