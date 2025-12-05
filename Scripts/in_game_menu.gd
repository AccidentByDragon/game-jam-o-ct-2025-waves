extends Control


func _on_restart_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
