extends Resource

export (String) var current_level = "res://World/Areas/Mudstreet/Start.tscn"
export (Vector2) var pos = Vector2(0, 0)
export (int) var max_health = 5
export (bool) var dash_unlocked = false
export (bool) var double_jump_unlocked = false

export (String) var last_level_save = "res://World/Areas/Mudstreet/Start.tscn"
export (String) var last_save_spawn_key = "Start"

export (Array) var bosses_killed = []
export (Array) var health_pickups_gotten = []

export (int) var completion_percent = 0
export (String) var spawn_area = "Mudstreet"
