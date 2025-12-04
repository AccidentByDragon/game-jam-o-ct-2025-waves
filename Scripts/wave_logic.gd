extends CharacterBody2D

class_name waveThreat
enum direction {north, east, south, west}
var current_direction: String

const speed: float = 250.0

var collided_with_player: bool = false
var dir: Vector2

func _process(delta):
	move(delta)
	move_and_slide()
	#print(current_direction)
func move(delta):
	velocity += dir * speed * delta
	
func set_direction(direction_string):
	match direction_string:
		"north":
			dir.y = 1
			current_direction = direction_string
		"east":
			dir.x = -1
			current_direction = direction_string
		"south":
			dir.y = -1
			current_direction = direction_string
		"west":
			dir.x = 1
			current_direction = direction_string

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.contains("Wave") != true:
		await get_tree().create_timer(0.5).timeout
		queue_free()
