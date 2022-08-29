extends Node2D

export var amount_of_bats = 0
export (float) var bat_spawn_delay = 0
export var left_spawn_limit = 0
export var right_spawn_limit = 0
export var spawn_height = 0

var bats_left_to_spawn = 0

onready var bat_scene = load("res://Enemy/Flyer/Scenes/RedBat.tscn")

func red_bat_summon():
	bats_left_to_spawn = amount_of_bats
	$BatSpawnTimer.start(bat_spawn_delay)
	get_parent().get_node("AnimationPlayer").play("SummonBats")

func _on_BatSpawnTimer_timeout():
	var bat_instance = bat_scene.instance()
	bat_instance.global_position = Vector2(rand_range(left_spawn_limit, right_spawn_limit), spawn_height)
	get_tree().get_nodes_in_group("Parent")[0].add_child(bat_instance)
	bats_left_to_spawn -= 1
	if bats_left_to_spawn > 0:
		$BatSpawnTimer.start(bat_spawn_delay)
