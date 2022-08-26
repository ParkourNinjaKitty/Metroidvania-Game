extends Control

func _on_VideoSettings_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/VideoSettings.tscn")

func _on_AudioSettings_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/AudioSettings.tscn")

func _on_KeyboardControls_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/KeyboardControls.tscn")

func _on_BackButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Scenes/MainMenu.tscn")
