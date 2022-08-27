extends Node2D

func ready():
	randomize()

func sweep():
	var direction = randi()
	if direction == 0:
		$AnimationPlayer.play("GroundSweepLeft")
	if direction == 1:
		$AnimationPlayer.play("GroundSweepRight")
