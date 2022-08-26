extends Area2D

var unlocked = false

func _ready():
	for i in PlayerStats.health_pickups_gotten:
		if i == str(get_tree().current_scene.filename):
			unlocked = true
			$Sprite.visible = false

func _on_Health_Pickup_body_entered(body):
	if body.is_in_group("Player"):
		if unlocked == false:
			unlocked = true
			$Sprite.visible = false
			PlayerStats.health_pickups_gotten.append(str(get_tree().current_scene.filename))
			
			PlayerStats.max_health += 1
			body.health = PlayerStats.max_health
			
			body.set_stats()
			
			SaveManager.save_file()
