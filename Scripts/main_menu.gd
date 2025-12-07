extends Control


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_help_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/help_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
