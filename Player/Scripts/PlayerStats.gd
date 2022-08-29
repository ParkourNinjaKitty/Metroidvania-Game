extends Node

var current_level = "res://World/Areas/Mudstreet/Start.tscn"
var pos = Vector2(0, 0)
var max_health = 5
var health = 5
var direction = 1
var dash_unlocked = false
var double_jump_unlocked = false
var enter_direction_key = null

var last_level_save = "res://World/Areas/Mudstreet/Start.tscn"
var last_save_spawn_key = "Start"

var bosses_killed = []
var health_pickups_gotten = []

var total_percent_items = 4
var completion_percent = 0

var spawn_area = "Mudstreet"

func calculate_completion_percentage():
	completion_percent = 0
	for i in bosses_killed:
		completion_percent += 1
	for i in health_pickups_gotten:
		completion_percent += 1
	if dash_unlocked:
		completion_percent += 1
	if double_jump_unlocked:
		completion_percent += 1
	completion_percent = int((float(completion_percent) / total_percent_items) * 100)
