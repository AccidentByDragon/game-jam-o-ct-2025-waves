extends Area2D

var game_over: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Wave"):
		print("deleting ", body.name)
		body.queue_free()
	elif body.name.contains("Player"):
		print("you left the scene")
		game_over = true
		body.queue_free()
		end_game()

func end_game():
	if game_over == true:
		get_tree().change_scene_to_file.call_deferred("res://Scenes/inGameMenu.tscn")
