extends Node2D

func vertical_bats():
	randomize()
	$Bats/HorizontalMovement.position.x = -randi() % 7
	$AnimationPlayer.play("VerticalBats")
