extends Area2D

@onready var game_manager: Node = %GameManager

func _on_body_entered(body: Node2D) -> void:
	game_manager.hard_collision()
	if body.name.contains("Wave"):
		print("deleting ", body.name)
		body.queue_free()
	elif body.name.contains("Player"):
		print("you left the scene")
		get_tree().reload_current_scene()
