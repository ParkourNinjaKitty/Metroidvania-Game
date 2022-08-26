extends Panel

export (int) var number = 0

func _ready():
	$"SaveNumber".text = ("Save " + str(number))
	if str(SaveManager.get_data_from_file(number)) != "False":
		$"NewFileText".visible = false
		$"FileInfo/PercentCompleted".text = str(SaveManager.get_data_from_file(number)[0]) + "%"
		$"FileInfo/CurrentArea".text = SaveManager.get_data_from_file(number)[1]
		$"FileInfo".visible = true
	if str(SaveManager.get_data_from_file(number)) == "False":
		$"FileInfo".visible = false
		$"NewFileText".visible = true

func _on_PlayButton_pressed():
	SaveManager.current_save = number
	
	if SaveManager.load_file() == false:
		SaveManager.save_file()
	SaveManager.load_file()
# warning-ignore:return_value_discarded
	get_tree().change_scene(PlayerStats.last_level_save)

func _on_DeleteButton_pressed():
	SaveManager.current_save = number
	
	SaveManager.delete_file()
	
	$"FileInfo".visible = false
	$"NewFileText".visible = true
