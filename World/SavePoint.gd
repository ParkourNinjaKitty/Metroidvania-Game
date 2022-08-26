extends Area2D

export (String) var enter_direction_key = null

func _on_SavePoint_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("Activated")
		
		PlayerStats.health = PlayerStats.max_health
		PlayerStats.last_level_save = str(get_tree().current_scene.filename)
		PlayerStats.last_save_spawn_key = enter_direction_key
		PlayerStats.spawn_area = str(get_tree().get_nodes_in_group("Parent")[0].name)
		
		body.set_stats()
		
		# Store some values.
		SaveManager.save_file()

func _on_SavePoint_body_exited(body):
	if body.is_in_group("Player"):
		PlayerStats.last_level_save = str(get_tree().current_scene.filename)
		PlayerStats.last_save_spawn_key = enter_direction_key
