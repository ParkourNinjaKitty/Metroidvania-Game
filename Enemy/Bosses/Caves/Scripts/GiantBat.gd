extends "res://Enemy/Bosses/Boss.gd"

enum phase1 {
	VERTICALBATS,
	GROUNDSWEEP,
	SUMMONBATS
}

enum phase2 {
	GROUNDSLAM,
	SUMMONREDBATS
}

enum phase3 {}

#phases
func phase1_func():
	velocity = Vector2(0, 0)
	var next_attack = phase1.keys()[randi() % phase1.size()]
	print(next_attack)
	if next_attack == "VERTICALBATS":
		verticalbats()
	if next_attack == "GROUNDSWEEP":
		groundsweep()
	if next_attack == "SUMMONBATS":
		summonbats()
	$Phase1Cooldown.start(phase1_attack_cooldown)

func phase2_func():
	velocity = Vector2(0, 0)
	var next_attack = phase2.keys()[randi() % phase2.size()]
	print(next_attack)
	if next_attack == "GROUNDSLAM":
		groundslam()
	if next_attack == "SUMMONREDBATS":
		summonredbats()
	$Phase2Cooldown.start(phase2_attack_cooldown)

func phase3_func():
	$Phase3Cooldown.start(phase3_attack_cooldown)

#phase 1 attacks
func verticalbats():
	$VerticalBats.call("vertical_bats")

func groundsweep():
	$GroundSweep.call("sweep")

func summonbats():
	$AnimationPlayer.play("SummonBats")

#phase 2 attacks
func groundslam():
	$AnimationPlayer.play("GroundSlamTelegraph")

func summonredbats():
	$AnimationPlayer.play("SummonRedBats")

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

func _on_Hurtbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		health -= area.get_parent().damage
		if $Sprite.frame <= 4:
			$HurtAnimationPlayer.play("UpsidedownHurt")
		elif $Sprite.frame <= 10:
			$HurtAnimationPlayer.play("FlyingHurt")
		elif $Sprite.frame <= 11:
			$HurtAnimationPlayer.play("SidewaysHurt")
