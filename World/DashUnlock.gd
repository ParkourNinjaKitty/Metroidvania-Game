extends Area2D


func _on_DashUnlock_body_entered(body):
	if body.is_in_group("Player"):
		if PlayerStats.dash_unlocked == false:
			body.dash_unlocked = true
			body.update_player_stats()
			
			SaveManager.save_file()
