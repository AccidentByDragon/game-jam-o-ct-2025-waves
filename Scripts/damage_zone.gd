extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Wave"):
		print("deleting ", body.name)
		body.queue_free()
	elif body.name.contains("Player"):
		print("you left the scene")
		get_tree().reload_current_scene()
