
# General

# Scripts & Code
  ## Game
  Code in the game section handles Spawning of waves and  some basic timers logic, before settling on how to manage collisons with wave I had planned to handle it hear
  I am paritcularly pleased with the wave spawnign functions as the guide i was orignally followed was a very simplistic version that went by each spawn point node by node with variables for each node and wave that was spawned at the node inside the For loop,
  I quickly realised a for loop could achieve this effect and be more resuable
 ### example 1: guide code (shortened for simplicity)
 
    for i in amount:
      var wave1 = wave.instantiate()
      wave1.global_postion = wave_spawn1.global_position
      var wave2 = wave.instatiate()
      wave2.global_position = wave_spawn2.global_position
      ....
  I decided to replace this with a nested for loop that used the "get_nodes_in_group" and the groups i organised the spawns points with to more cleanly spawn the waves, later ealised i could seperate the loop out into its own fuction and reuse it allowing me to call it for     each direction and achieve the same effect with less code in tidier fashion
  ### example 2: reusable loop

    func spawn_wave(amount, spawn_point, wait_between_waves):
	    if spawn_point == "north":
		    wavespawnloop("NorthSpawns", amount, wait_between_waves)	
	    if spawn_point == "south":
		    wavespawnloop("SouthSpawns", amount, wait_between_waves)
	    if spawn_point == "west":
		    wavespawnloop("WestSpawns", amount, wait_between_waves)
	    if spawn_point == "east":
		    wavespawnloop("EastSpawns", amount, wait_between_waves)

    func wavespawnloop(origin, amount, wave_timer):
	    var spawns = get_tree().get_nodes_in_group(origin)
	    var current_wave_number: int = 1 
	    for i in amount:
		    for point in spawns:
			    current_wave_number += 1
			    var new_wave = wave.instantiate()
			    new_wave.global_position = point.global_position
			    add_child(new_wave)
			    print("Spawning wave at: ", point.name, " wave number: ", current_wave_number)
			    if point == spawns.back():
				    break
		    amount -= 1
		    await get_tree().create_timer(wave_timer).timeout

  I also realise this could all be folded into a single line of code if i rename the wave spawn point groups or ensure that the "spawn_point" varaible fed too spawn_wave is the correct string name for the wave spawn groups
  ## Game Manager
  created to handle damaging collisions with rocks initially, may be removed in later on should I change the rocks to be rigidBodies inorder
  ## Boat
  created to manage palyer input and velocity, made speed and turing variables exports inorder ot easily handle them in the inspector,
  the code is designed to allow the palyer to gradually accelerate up to their max speed and only slow down if the palyer brakes or to slowly slow down while not accelrating,
  this is achieved by making "velocity = transform.x * currentspeed" this allows the speed to increase over time and be applied in the direction of facing, this results in the player drifting around in the game,
  will likely attempt to make a way to slow the players non forward momentum more quickly than forward momentum reduction

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
	
  ## Collison zone 
  originally created to monitor collisions between player and hard obstacles, may eventually repurpose to destroy waves upon leaving the screen or removed entirely
  ## Wave logic
   handles the movement of the waves and their collisions effects, msotly jsut tells the waves to face a point and moves them in that direction
  
# Organisation
  Nodes have been structured relatively freely, grouped the Spawning points for waves into groups based on the cardinal direction they are positioned inorder to locate them via
  a For loop in script, in the Node tree all waves spawn points are gathered under a "SpawnPoints" parent node to keep tree clearer
