extends Area2D

export var tilemap_door_cells = []
export var boss = ""

var been_triggered = false

func _ready():
	for i in PlayerStats.bosses_killed:
		if i == boss:
			been_triggered = true

func _on_BossroomDoorTrigger_body_entered(body):
	if been_triggered == false:
		if body.is_in_group("Player"):
			been_triggered = true
			for i in get_tree().get_nodes_in_group("Boss"):
				i.spawn()
			for i in tilemap_door_cells:
				get_parent().set_cellv(i, 0)
			get_parent().update_bitmask_region()

func open_bossroom_doors():
	for i in tilemap_door_cells:
		get_parent().set_cellv(i, -1)
	get_parent().update_bitmask_region()
