extends Node

export (Script) var game_save_class = load("res://game_save.gd")
export (int) var current_save = null

func verify_save(file_save):
	if not file_save is game_save_class:
		return false
	
	return true

func save_file():
	var new_save = game_save_class.new()
	
	new_save.current_level = PlayerStats.current_level
	new_save.pos = PlayerStats.pos
	new_save.max_health = PlayerStats.max_health
	new_save.dash_unlocked = PlayerStats.dash_unlocked
	new_save.double_jump_unlocked = PlayerStats.double_jump_unlocked
	
	new_save.last_level_save = PlayerStats.last_level_save
	new_save.last_save_spawn_key = PlayerStats.last_save_spawn_key
	
	new_save.bosses_killed = PlayerStats.bosses_killed
	new_save.health_pickups_gotten = PlayerStats.health_pickups_gotten
	
	PlayerStats.calculate_completion_percentage()
	new_save.completion_percent = PlayerStats.completion_percent
	
	new_save.spawn_area = PlayerStats.spawn_area
	
	var dir = Directory.new()
	if not dir.dir_exists("user://saves/"):
		dir.make_dir_recursive("user://saves/")
	
# warning-ignore:return_value_discarded
	ResourceSaver.save("user://saves/save_" + str(current_save) + ".res", new_save)

func load_file():
	var dir = Directory.new()
	if not dir.file_exists("user://saves/save_" + str(current_save) + ".res"):
		print("directory doesn't exist")
		return false
	
	var file_save = load("user://saves/save_" + str(current_save) + ".res")
	
	if not verify_save(file_save):
		print("couldn't verify save file")
		return false
	
	PlayerStats.current_level = file_save.current_level
	PlayerStats.pos = file_save.pos
	PlayerStats.max_health = file_save.max_health
	PlayerStats.dash_unlocked = file_save.dash_unlocked
	PlayerStats.double_jump_unlocked = file_save.double_jump_unlocked
	
	PlayerStats.last_level_save = file_save.last_level_save
	PlayerStats.last_save_spawn_key = file_save.last_save_spawn_key
	
	PlayerStats.bosses_killed = file_save.bosses_killed
	PlayerStats.health_pickups_gotten = file_save.health_pickups_gotten
	
	PlayerStats.enter_direction_key = PlayerStats.last_save_spawn_key
	
	return true

func delete_file():
	var dir = Directory.new()
	if dir.file_exists("user://saves/save_" + str(current_save) + ".res"):
		dir.remove("user://saves/save_" + str(current_save) + ".res")

func get_data_from_file(number):
	var dir = Directory.new()
	if not dir.file_exists("user://saves/save_" + str(number) + ".res"):
		print("directory doesn't exist")
		return false
	
	var file_save = load("user://saves/save_" + str(number) + ".res")
	
	if not verify_save(file_save):
		print("couldn't verify save file")
		return false
	
	return [file_save.completion_percent, file_save.spawn_area]
