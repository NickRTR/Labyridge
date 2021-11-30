extends KinematicBody2D

var speed = 50
var direction = Vector2(0, -speed)

var dead = false
var won = false

var tutorial = false
var counter = 0

signal dead
signal win

func _physics_process(_delta):
	move_and_slide(direction)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision != null:
			if collision.collider.name == "Console":
				$Tween.interpolate_callback(self, 1.5, "win")
				$Tween.start()
				if !won:
					$Win/Particles.emitting = true
					$Win/Win.play()
				won = true
			randomize()
			move(collision)
			
	if !dead:
		lava()


func move(collision):
	var input
	
	if Input.is_action_just_pressed("ui_right"):
		input = 1
	elif Input.is_action_just_pressed("ui_left"):
		input = 2
	elif Input.is_action_just_pressed("ui_up"):
		input = 3

	if !tutorial:
		if input != null and randi() % 4 + 1 == 1 and input != 3 and !collision_on_side(collision):
			$ChangeDirection/ChangeDirection.play()
			$ChangeDirection/Particles.emitting = true
			if input == 1:
				turn(2)
			elif input == 2:
				turn(1)
		else:
			turn(input)
	else:
		if input != null:
			counter += 1
			if counter == 3:
				$ChangeDirection/ChangeDirection.play()
				$ChangeDirection/Particles.emitting = true
				if input == 1:
					turn(2)
				elif input == 2:
					turn(1)
			else:
				turn(input)


func collision_on_side(collision):
	
	var collision_distance = (position - collision.position).normalized()
	var collision_side

	if collision_distance.x > 0 and collision_distance.y > 0:
		collision_side = 3
	elif collision_distance.x > 0 and collision_distance.y < 0:
		collision_side = 2
	elif collision_distance.x < 0 and collision_distance.y > 0:
		collision_side = 1
	
	if collision_side == 1 || collision_side == 2:
		return true
	else:
		return false


func turn(input):
	
	# 1 = right
	# 2 = left
	# 3 = up
	
	if input == 1:
		rotation = PI / 2
		$Sprite.flip_v = false
		$Sprite.flip_h = false
		direction = Vector2(speed, 0)
	elif input == 2:
		rotation = PI / -2
		$Sprite.flip_v = false
		$Sprite.flip_h = false
		direction = Vector2(-speed, 0)
	elif input == 3:
		rotation = PI
		$Sprite.flip_v = true
		$Sprite.flip_h = true
		direction = Vector2(0, -speed)


func lava():
	var tilemap = get_node("/root/Scene Handler/Game/Map/Tilemap")
	
	var character_global_position = global_position
	var position_relative_tilemap = tilemap.to_local(character_global_position)
	var character_coords = tilemap.world_to_map(position_relative_tilemap)
	var tile = tilemap.get_cellv(character_coords)
	
	if tile == 3:
		set_physics_process(false)
		$Tween.interpolate_callback(self, 1, "die")
		$Tween.start()
		if !dead:
			$Dead/Hit.play()
			$Dead/Particles.emitting = true
			dead = true


func win():
	emit_signal("win")


func die():
	emit_signal("dead")

