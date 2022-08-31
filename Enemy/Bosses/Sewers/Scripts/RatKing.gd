extends "res://Enemy/Bosses/Boss.gd"

enum phase1 {
	SCEPTERSWING,
	CHASE
}

enum phase2 {
	SCEPTERTHROW,
	JUMP
}

enum phase3 {
	RATRAIN,
	DASH
}

#phases
func phase1_func():
	velocity = Vector2(0, 0)
	var next_attack = phase1.keys()[randi() % phase1.size()]
	var x_distance_to_player = global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x
	if abs(x_distance_to_player) < 36:
		next_attack = "SCEPTERSWING"
	if abs(x_distance_to_player) > 44:
		next_attack = "CHASE"
	if next_attack == "SCEPTERSWING":
		scepterswing()
	if next_attack == "CHASE":
		chase()
	$Phase1Cooldown.start(phase1_attack_cooldown)

func phase2_func():
	velocity = Vector2(0, 0)
	var next_attack = phase2.keys()[randi() % phase2.size()]
	if next_attack == "SCEPTERTHROW":
		scepterthrow()
	if next_attack == "JUMP":
		jump()
	$Phase2Cooldown.start(phase2_attack_cooldown)

func phase3_func():
	velocity = Vector2(0, 0)
	var next_attack = phase3.keys()[randi() % phase3.size()]
	if next_attack == "RATRAIN":
		ratrain()
	if next_attack == "DASH":
		dash()
	$Phase3Cooldown.start(phase3_attack_cooldown)

#phase 1 attacks
func scepterswing():
	$Scepter.swing()

func chase():
	$ChaseAttack.chase()

#phase 2 attacks
func scepterthrow():
	$Scepter.throw()

func jump():
	$AnimationPlayer.play("JumpTelegraph")

#phsae 3 attacks
func ratrain():
	$RatRainAttack.rat_rain()

func dash():
	if global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x > 0:
		$Sprite.flip(false)
	else:
		$Sprite.flip(true)
	$AnimationPlayer.play("DashTelegraph")

#cooldown timers
func _on_Phase1Cooldown_timeout():
	if phase == phases.PHASE1:
		phase1_func()
	else:
		$PhaseTransitions.play("Phase2")

func _on_Phase2Cooldown_timeout():
	if phase == phases.PHASE2:
		phase2_func()
	else:
		$PhaseTransitions.play("Phase3")

func _on_Phase3Cooldown_timeout():
	if phase == phases.PHASE3:
		phase3_func()
