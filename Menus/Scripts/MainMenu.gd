extends Control

func _on_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/SaveSelection.tscn")

func _on_OptionsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/OptionsMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
