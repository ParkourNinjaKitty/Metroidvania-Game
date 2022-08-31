extends Node2D

export var chase_attack_length = 0
export var chase_speed = 0
export var direction_change_leeway = 0

var is_attacking = false

func _process(_delta):
	if is_attacking == true:
		if global_position.x-get_tree().get_nodes_in_group("Player")[0].global_position.x <= -direction_change_leeway:
			get_parent().velocity = Vector2(chase_speed, 0)
			get_parent().get_node("Sprite").flip(true)
		if global_position.x-get_tree().get_nodes_in_group("Player")[0].global_position.x >= direction_change_leeway:
			get_parent().velocity = Vector2(-chase_speed, 0)
			get_parent().get_node("Sprite").flip(false)

func chase():
	$ChaseAttackTimer.start(chase_attack_length)
	is_attacking = true
	get_parent().velocity = Vector2((global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x) * chase_speed, 0)
	get_parent().get_node("AnimationPlayer").play("Run")

func _on_ChaseAttackTimer_timeout():
	is_attacking = false
	get_parent().velocity = Vector2(0, 0)
	get_parent().get_node("AnimationPlayer").play("Idle")
