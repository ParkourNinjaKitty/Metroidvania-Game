extends Position2D

export (String) var enter_direction_key = null
export (Vector2) var spawn_velocity = Vector2(0, 0)
export (int) var default_direction = 0
export (int) var force_direction = 0

func _ready():
	if force_direction == 0:
		if PlayerStats.direction != 0:
			spawn_velocity.x *= PlayerStats.direction
		else:
			spawn_velocity.x *= default_direction
	if force_direction != null and force_direction != 0:
		spawn_velocity.x *= force_direction
