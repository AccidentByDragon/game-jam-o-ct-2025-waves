extends CharacterBody2D

@export var MaxSpeed: float
@export var DecelerationSpeed: float
@export var rotation_speed = 1.5
var CurrentSpeed: float
var rotation_direction = 0

func _physics_process(delta: float) -> void:
	#move forward in facing direction
	rotation_direction = Input.get_axis("turn_left", "turn_right")
	if Input.is_action_pressed("move_forward"):
		CurrentSpeed += 50.0
		if CurrentSpeed > MaxSpeed:
			CurrentSpeed = MaxSpeed
	if Input.is_action_pressed("slow_movement"):
		CurrentSpeed -= 50.0
		if CurrentSpeed < -200:
			CurrentSpeed = -200
	else:
		CurrentSpeed -= DecelerationSpeed * delta
		if CurrentSpeed < 0:
			CurrentSpeed = 0

	velocity = transform.x * CurrentSpeed
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
