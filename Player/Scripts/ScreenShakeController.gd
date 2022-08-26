extends Node

onready var PlayerCamera = get_tree().get_nodes_in_group("Player")[0].get_node("Camera2D")

func shake(amount : float):
	PlayerCamera.add_trauma(amount)
