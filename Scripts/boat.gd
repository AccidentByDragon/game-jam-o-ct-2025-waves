extends CharacterBody2D


@export var max_speed: float
@export var deceleration_speed: float
@export var rotation_speed = 1.5
var curent_speed: float
var rotation_direction = 0
const collision_force: float = 250.0
var player_health = 100
var is_knocked_back: bool = false

#var knockback_direction = Vector2()
#var knockback_wait = 10

func _physics_process(delta: float) -> void:
	#move forward in facing direction
	rotation_direction = Input.get_axis("turn_left", "turn_right")
	if Input.is_action_pressed("move_forward"):
		curent_speed += 50.0
		if curent_speed > max_speed:
			curent_speed = max_speed
	if Input.is_action_pressed("slow_movement"):
		curent_speed -= 50.0
		if curent_speed < -200:
			curent_speed = -200
	else:
		curent_speed -= deceleration_speed * delta
		if curent_speed < 0:
			curent_speed = 0
			is_knocked_back = false # this solved our issue as it gives us a chnace to disable the shove
	if is_knocked_back == true:
		for index in get_slide_collision_count():
			var collision: KinematicCollision2D = get_slide_collision(index)
			if collision.get_collider().name.contains("Wave"):
				velocity = collision.get_normal()*curent_speed
	elif is_knocked_back != true:
		velocity = transform.x * curent_speed
		rotation += rotation_direction * rotation_speed * delta
	move_and_slide()


func _on_wave_collision_detection_body_entered(body: Node2D) -> void:
	if body.name.contains("Rock"):
		print("player has hit ", body.name)
		player_health = player_health -25
		print(player_health)
	elif body.name.contains("Wave"):
		print("a wave has hit player")
		player_health = player_health -10
		curent_speed = collision_force
		is_knocked_back = true
		#var knockback_direction = body.position.direction_to(self.position)
		#print(knockback_direction)
		#velocity = knockback_direction * collision_force # this telports the player rather than sliding them
		# tried this, still no luck
		#if knockback_direction.x !=0:
			#velocity = transform.x * collision_force 
		#elif knockback_direction.y != 0:
			#velocity = transform.y * collision_force 
