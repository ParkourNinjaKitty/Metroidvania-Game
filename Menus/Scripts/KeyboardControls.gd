extends Control

func _on_BackButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/OptionsMenu.tscn")
