extends StaticBody2D

@onready var game_manager: Node = %GameManager

func _on_area_2d_body_entered(body: Node2D) -> void:
	game_manager.hard_collision()
