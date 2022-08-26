extends Control

var menu_open = false

func _process(_delta):
	menu_open = visible
	if menu_open == false:
		if Input.is_action_just_pressed("pause_game"):
			print("menu open is false")
			get_tree().paused = true
			visible = true
	if menu_open == true:
		if Input.is_action_just_pressed("pause_game"):
			print("menu open is true")
			visible = false
			get_tree().paused = false
