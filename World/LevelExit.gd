extends Area2D

export (String) var next_level = null
export (String) var enter_direction_key = null

func _on_LevelChanger_body_entered(body):
	if body.is_in_group("Player"):
		PlayerStats.enter_direction_key = enter_direction_key
		PlayerStats.current_level = next_level
		body.update_player_stats()
# warning-ignore:return_value_discarded
		get_tree().change_scene(next_level)
