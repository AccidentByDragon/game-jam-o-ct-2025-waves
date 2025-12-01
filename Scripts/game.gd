extends Node2D

@onready var timer: Timer = $Timer
@onready var player = $Player

var currentWave: int
@export var wave: PackedScene

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended

func _ready():
	print("ready")
	currentWave = 0
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()

func position_to_next_wave():	
	print(currentWave)
	if current_nodes == starting_nodes:
		currentWave += 1		
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("north", 2.0, 1.0) #Origin of waves, Number of "waves",  time between waves
		print(currentWave)

func prepare_spawn(origin, multiplier, timeBetween):
	var wave_amount = float(currentWave) * multiplier
	var wave_wait_time = timeBetween
	print("wave_amount: ", wave_amount, "wave_wait_time: ", wave_wait_time)
	spawn_wave(wave_amount, origin, wave_wait_time)

func spawn_wave(amount, spawn_point, wait_between_waves):
	if spawn_point == "north":
		var north_spawns = get_tree().get_nodes_in_group("NorthSpawns")
		var current_wave_number: int = 1
		if amount >=1:
			for i in amount:
				for point in north_spawns:
					current_wave_number += 1
					var new_wave = wave.instantiate()
					new_wave.global_position = point.global_position
					add_child(new_wave)
					print("Spawning wave at: ", point.name, " wave number: ", current_wave_number)
					if point == north_spawns.back():
						break
				amount -= 1
				await get_tree().create_timer(wait_between_waves).timeout
	if spawn_point == "south":
		var south_spawns = get_tree().get_nodes_in_group("SouthSpawns")
		var current_wave_number: int = 1
		if amount >=1:
			for i in amount:
				for point in south_spawns:
					current_wave_number += 1
					var new_wave = wave.instantiate()
					new_wave.global_position = point.global_position
					add_child(new_wave)
					print("Spawning wave at: ", point.name, " wave number: ", current_wave_number)
					if point == south_spawns.back():
						break
				amount -= 1
				await get_tree().create_timer(wait_between_waves).timeout
	if spawn_point == "west":
		var west_spawns = get_tree().get_nodes_in_group("WestSpawns")
		var current_wave_number: int = 1
		if amount >=1:
			for i in amount:
				for point in west_spawns:
					current_wave_number += 1
					var new_wave = wave.instantiate()
					new_wave.global_position = point.global_position
					add_child(new_wave)
					print("Spawning wave at: ", point.name, " wave number: ", current_wave_number)
					if point == west_spawns.back():
						break
				amount -= 1
				await get_tree().create_timer(wait_between_waves).timeout
	if spawn_point == "east":
		var east_spawns = get_tree().get_nodes_in_group("EastSpawns")
		var current_wave_number: int = 1
		if amount >=1:
			for i in amount:
				for point in east_spawns:
					current_wave_number += 1
					var new_wave = wave.instantiate()
					new_wave.global_position = point.global_position
					add_child(new_wave)
					print("Spawning wave at: ", point.name, " wave number: ", current_wave_number)
					if point == east_spawns.back():
						break
				amount -= 1
				await get_tree().create_timer(wait_between_waves).timeout

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0

func bounceOnCollision():
	pass
