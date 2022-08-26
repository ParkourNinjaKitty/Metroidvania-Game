extends "res://Enemy/Crawler/Scripts/CrawlerMovement.gd"

func _ready():
	GRAVITY = -GRAVITY

func _on_FallTrigger_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("Fall")

func fall():
	GRAVITY = -GRAVITY
	$AnimationPlayer.play("Walk")
