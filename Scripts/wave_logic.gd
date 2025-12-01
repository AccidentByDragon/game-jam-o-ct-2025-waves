extends CharacterBody2D

class_name waveThreat
enum {NORTH, EAST, SOUTH, WEST}

const speed: float = 250.0

var collided_with_player: bool = false
var dir: Vector2

func _process(delta):
	pass
