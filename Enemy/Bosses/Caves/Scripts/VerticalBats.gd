extends Node2D

func vertical_bats():
	get_tree().get_nodes_in_group("Boss")[0].get_node("AnimationPlayer").stop()
	randomize()
	$Bats/HorizontalMovement.position.x = (-randi() % 21) - 7
	$Particles.position.x = $Bats/HorizontalMovement.position.x
	$AnimationPlayer.play("VerticalBats")
