extends Area2D

@onready var gameManager: Node = %GameManager

func _on_body_entered(body: Node2D) -> void:
	print("hard collision")
	gameManager.hard_collision(body)
