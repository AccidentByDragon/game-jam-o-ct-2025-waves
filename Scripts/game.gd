extends Node2D

@onready var timer: Timer = $Timer
@onready var player = $Player

var current_wave: int
@export var wave: PackedScene

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended

func _ready():
	current_wave = 0
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()

func _process(delta: float) -> void:
	current_nodes = get_child_count()
	if wave_spawn_ended == true:
		position_to_next_wave()

func position_to_next_wave():
	if current_nodes == starting_nodes:
		wave_spawn_ended = false
		current_wave += 1
		await get_tree().create_timer(0.5).timeout
		var wave_origin = choose(["north", "east", "south", "west"])
		prepare_spawn(wave_origin, current_wave* 1.0, 2.0) #Origin of waves, Number of "waves",  time between waves

func prepare_spawn(origin, multiplier, timeBetween):
	var wave_amount = float(current_wave) * multiplier
	var wave_wait_time = timeBetween
	spawn_wave(wave_amount, origin, wave_wait_time)

func spawn_wave(amount, origin, wait_between_waves):
	var spawns = get_tree().get_nodes_in_group(origin)
	var current_wave_number: int = 1 
	for i in amount:
		for point in spawns:
			current_wave_number += 1
			var new_wave = wave.instantiate()
			new_wave.global_position = point.global_position
			add_child(new_wave)
			new_wave.set_direction(origin)
			var new_wave_name = "Wave"+ str(current_wave_number)
			new_wave.set_name(new_wave_name) 
			if point == spawns.back():
				break
		amount -= 1
		await get_tree().create_timer(wait_between_waves).timeout
		## this orignally would go through the spawn point swithout a for loop so would have each spawnpoint have its own variable
		## and then spawn a wave add it trhough its own variable, i replaced this with a for loop that utilised get_nodes_in_group to make a cleaner code
		## that achieved the same effect.
	wave_spawn_ended = true

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0

func choose(array):
	array.shuffle()
	return array.front()
