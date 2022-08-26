extends "res://Enemy/Bosses/Boss.gd"

enum phase1 {
	HORIZONTALBATS,
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
	if next_attack == "HORIZONTALBATS":
		horizontalbats()
	if next_attack == "VERTICALBATS":
		verticalbats()
	if next_attack == "GROUNDSWEEP":
		groundsweep()
	if next_attack == "SUMMONBATS":
		summonbats()
	$Phase1Cooldown.start(phase1_attack_cooldown)

func phase2_func():
	velocity = Vector2(0, 0)
	var next_attack = phase1.keys()[randi() % phase1.size()]
	if next_attack == "GROUNDSLAM":
		groundslam()
	if next_attack == "SUMMONREDBATS":
		summonredbats()
	$Phase2Cooldown.start(phase2_attack_cooldown)

func phase3_func():
	$Phase3Cooldown.start(phase3_attack_cooldown)

#phase 1 attacks
func horizontalbats():
	pass

func verticalbats():
	pass

func groundsweep():
	pass

func summonbats():
	pass

#phase 2 attacks
func groundslam():
	pass

func summonredbats():
	pass

#cooldown timers
func _on_Phase1Cooldown_timeout():
	if phase == phases.PHASE1:
		phase1_func()

func _on_Phase2Cooldown_timeout():
	if phase == phases.PHASE2:
		phase2_func()

func _on_Phase3Cooldown_timeout():
	if phase == phases.PHASE3:
		phase3_func()
