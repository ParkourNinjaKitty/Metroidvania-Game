extends Node2D

export var amount_of_rats = 0
export (float) var rat_spawn_delay = 0
export var left_spawn_limit = 0
export var right_spawn_limit = 0
export var spawn_height = 0

var rats_left_to_spawn = 0

onready var rat_scene = load("res://Enemy/Crawler/Scenes/Rat.tscn")

func rat_rain():
	rats_left_to_spawn = amount_of_rats
	$RatSpawnTimer.start(rat_spawn_delay)
	if global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x < 0:
		get_parent().get_node("AnimationPlayer").play("RatRainRight")
	else:
		get_parent().get_node("AnimationPlayer").play("RatRainLeft")

func _on_RatSpawnTimer_timeout():
	var rat_instance = rat_scene.instance()
	rat_instance.global_position = Vector2(rand_range(left_spawn_limit, right_spawn_limit), spawn_height)
	get_tree().get_nodes_in_group("Parent")[0].add_child(rat_instance)
	rats_left_to_spawn -= 1
	if rats_left_to_spawn > 0:
		$RatSpawnTimer.start(rat_spawn_delay)
