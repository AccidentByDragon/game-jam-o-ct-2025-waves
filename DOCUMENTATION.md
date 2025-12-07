
# General

# Scripts & Code
  ## Game
  Code in the game section handles Spawning of waves and  some basic timers logic, before settling on how to manage collisons with wave I had planned to handle it hear
  I am paritcularly pleased with the wave spawning functions as the guide I was orignally followed was a very simplistic version that went by each spawn point node by node with variables for each node and wave that 
  was spawned at the node inside the For loop,
  I quickly realised a for loop could achieve this effect and be more resuable
 ### Figure 1: guide code (shortened for simplicity)
 
    for i in amount:
      var wave1 = wave.instantiate()
      wave1.global_postion = wave_spawn1.global_position
      var wave2 = wave.instatiate()
      wave2.global_position = wave_spawn2.global_position
      ....
  I decided to replace this with a nested for loop that used the "get_nodes_in_group" and the groups i organised the spawns points with to more cleanly spawn the waves, later ealised i could seperate the loop out into its 
  own fuction and reuse it allowing me to call it for each direction and achieve the same effect with less code in tidier fashion
  ### Figure 2: reusable loop

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
  to do this i renamed the groups in the inspector to simply be north, east, south and west allowing me to create a single loop that got the location the waves needed to be spawned at and then created them.
  
### Figure 3: merged reusable loop

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
				print("Spawning wave at: ", point.name, " wave number: ", current_wave_number)
				if point == spawns.back():
					break
			amount -= 1
			await get_tree().create_timer(wait_between_waves).timeout

04/12 added a litle _process and choose() dunctions to allow randomisation of wave orign and spawning new waves when previous waves are deleted
  
  ## Game Manager
  Created to handle damaging collisions with rocks initially, may be removed in later on should I change the rocks to be rigidBodies inorder
  04/12 deleted along with rock.gd as it was no longer needed
  
  ## Boat/Player
  Created to manage player input and velocity, made speed and turing variables exports inorder to easily handle them in the inspector,
  the code is designed to allow the palyer to gradually accelerate up to their max speed and only slow down if the palyer brakes or to slowly slow down while not accelrating,
  this is achieved by making "velocity = transform.x * currentspeed" this allows the speed to increase over time and be applied in the direction of facing, this results in the player drifting around in the game,
  will likely attempt to make a way to slow the players non forward momentum more quickly than forward momentum reduction

  ### Figure 4: basic movement version of _physics_process

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

  03/12. 
  I decided that the easiest way to handle the collisions for the player colliding with rocks and being hit with waves would be to manage all such thing by the player this also opens the opportunity for me to delete
  the gamemanager i made to handle hp and collisions originally and delegate the collisons to the relevant nodes, such as the boat script and the wave script, for the boat collison i did the following
  ### Figure 5: Initial collision detection for boat/player
  	func _on_wave_collision_detection_body_entered(body: Node2D) -> void:
		if body.name.contains("Rock"):
			print("player has hit ", body.name)
			player_health = player_health -10
			print(player_health)
		elif body.name.contains("Wave"):
			print("a wave has hit player")
			var knockback_direction = body.position.direction_to(self.position)
			print(knockback_direction)
			velocity = knockback_direction * collision_force # this telports the player rather than sliding them
			move_and_slide()
		
  I did however strike a problem in that the code to kncok the player in the direction the wave was headed teleported the palyer instantly rather than sliding them as i had intended, my current theory is this is due 
  to using a vector2 for knockback_direction on its own is the cause of the issue

  04/12.
  managed to find a solution to previous problems by changing the colision detection to the following

  ### Figure 6: collision detection
  
  	func _on_wave_collision_detection_body_entered(body: Node2D) -> void:
		if body.name.contains("Rock"):
			print("player has hit ", body.name)
			player_health = player_health -10
			print(player_health)
		elif body.name.contains("Wave"):
			print("a wave has hit player")
			curent_speed = collision_force
			if curent_speed <= 0:
				is_knocked_back = false
			else:
				is_knocked_back = true

  updated the _physics_process to allow this to move the player, however the current method does not slow down over time as is desired
  
  ### Figure 7: _physics_process with knockbacks
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
		curent_speed -= deceleration_speed * delta
		if curent_speed < 0:
			curent_speed = 0
		if is_knocked_back == true:
			for index in get_slide_collision_count():
				var collision: KinematicCollision2D = get_slide_collision(index)
				if collision.get_collider().name.contains("Wave"):
					velocity = collision.get_normal()*curent_speed # this combined with how we disable colisions is a problem
		elif is_knocked_back != true:
			velocity = transform.x * curent_speed # the transform.x is causing us issues with knockback
			rotation += rotation_direction * rotation_speed * delta
		move_and_slide()

  05/12.
  solved the collision issue by restructuring the code and allowing the collison to be stopped before the code, their are still some buggy behaviours in the code, however I am not sure how to sovle this with my 
  current understanding of Godot the physics engine.I am aware that the way I Handle the forward momentum is the reaosn the knockback and movement is buggy,
  it may be possible to solve it with a few tweaks to the movement by applying move_towards in the movement and replacing the forward and slow momentum if statements, will expereiment in a new branch after creating option 
  and instruction sections of main menu.
  ### Figure 8: functional iteration of _physics_process
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
				is_knocked_back = false # this solved our issue as it gives us a chance to disable the shove
		if is_knocked_back == true:
			for index in get_slide_collision_count():
				var collision: KinematicCollision2D = get_slide_collision(index)
				if collision.get_collider().name.contains("Wave"):
					velocity = collision.get_normal()*curent_speed
		elif is_knocked_back != true:
			velocity = transform.x * curent_speed
			rotation += rotation_direction * rotation_speed * delta
		move_and_slide()

  ### Figure 9: collision function
	  func _on_wave_collision_detection_body_entered(body: Node2D) -> void:
		if body.name.contains("Rock"):
			print("player has hit ", body.name)
			player_health = player_health -25
			health_check()
			print(player_health)
		elif body.name.contains("Wave"):
			print("a wave has hit player")
			player_health = player_health -10
			health_check()
			curent_speed = collision_force
			is_knocked_back = true
  I also added a way for the player to take damage and lose the game and a heath bar to show this, to avoid the palyer repeatedly taking damage I added a timer to prevent more damage from rocks after initial collision
  ## Collison zone 
  originally created to monitor collisions between player and hard obstacles
  
  03/12.
  I eventually repurposed to destroy waves upon leaving the screen and restart the scene if player enters the zones which have been placed at the edges outside the camera bounds

  05/12. with the addition of menus the player leaving the scene will now load the game over menu instead
  
  ## Wave logic
   handles the movement of the waves and their collisions effects, msotly jsut tells the waves to face a point and moves them in that direction
   this primarily became a palce to determine the direction the waves needed to head and the dictated their direction, I achieved this by creating a class which allowed me to access varaibles and call functions when 
   spawning in the waves, because the waves are being spawned by the a script on Game node this is a perfectly valid way of doing things, I only directly call one specific function to set the direction

## Main menu and in Game menu
these two are fairly straight forward in that they are designed to allow a player to start/restart the game, exit to menu or quit entirely by calling the scene_tree
  
# Organisation
  Nodes have been structured relatively freely, grouped the Spawning points for waves into groups based on the cardinal direction they are positioned inorder to locate them via
  a For loop in script, in the Node tree all waves spawn points are gathered under a "SpawnPoints" parent node to keep tree clearer
  
