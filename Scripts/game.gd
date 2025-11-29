extends Node2D

@onready var timer: Timer = $Timer
@onready var player = $Player

var currentWave: int
@export var wave: PackedScene

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended

func _ready():
	currentWave = 0
	starting_nodes = get_child_count()
	currentWave = get_child_count()
	position_to_next_wave()

func position_to_next_wave():
	if current_nodes == starting_nodes:
		if currentWave != 0:
			pass
		currentWave += 1
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("north", 4.0, "south") #Direciton of waves, Number of "waves", origin point of waves

func prepare_spawn( direction, multiplier,  origin):
	var wave_amount = float(currentWave) * multiplier
	

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0

func bounceOnCollision():
	pass
