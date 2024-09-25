class_name Spawner extends Node2D

const food_scene : PackedScene = preload("res://gameplay/food.tscn")
const collision_detector_scene : PackedScene = preload("res://gameplay/collision_detector.tscn")

# export vars
@export var bounds: Bounds

func generate_spawn_point() -> Vector2:
	# Where to spawn (Position)
	var spawn_point : Vector2 = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Globals.GRID_SIZE, bounds.x_max - Globals.GRID_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Globals.GRID_SIZE, bounds.y_max - Globals.GRID_SIZE)
	
	spawn_point.x = floorf(spawn_point.x / Globals.GRID_SIZE) * Globals.GRID_SIZE
	spawn_point.y = floorf(spawn_point.y / Globals.GRID_SIZE) * Globals.GRID_SIZE
	
	#var collision_detector : CollisionDetector = collision_detector_scene.instantiate()
	#collision_detector.position = spawn_point
	#get_parent().add_child(collision_detector)
	#print(collision_detector.get_overlapping_areas())
	#if not collision_detector.get_overlapping_areas().is_empty():
		#print("Rechecking Spawn Point!")
		##collision_detector.queue_free()
		#return generate_spawn_point()
	#
	##collision_detector.queue_free()
	return spawn_point

func spawn_food() -> Food:
	var spawn_point : Vector2 = generate_spawn_point()
	
	
	# What we're spawning (Instantiating)
	var food = food_scene.instantiate()
	food.position = spawn_point
	# Where we're putting it (Parenting)
	get_parent().call_deferred("add_child", food)
	#get_parent().add_child(food)
	return food

func spawn_player_position(_index, _no_of_sections) -> Vector2:
	var spawn_point : Vector2 = generate_spawn_point()
	
	return spawn_point
