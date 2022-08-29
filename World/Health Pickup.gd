extends Area2D

var unlocked = false

func _ready():
	for i in PlayerStats.health_pickups_gotten:
		if i == str(get_tree().current_scene.filename):
			unlocked = true
			disable()

func _on_Health_Pickup_body_entered(body):
	if body.is_in_group("Player"):
		if unlocked == false:
			unlocked = true
			disable()
			PlayerStats.health_pickups_gotten.append(str(get_tree().current_scene.filename))
			
			PlayerStats.max_health += 1
			body.health = PlayerStats.max_health
			
			body.set_stats()
			
			SaveManager.save_file()

func disable():
	$Sprite.visible = false
	$Particles2D.visible = false
	$Particles2D2.visible = false
	$Light2D.visible = false
