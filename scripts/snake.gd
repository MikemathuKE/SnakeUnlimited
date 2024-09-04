class_name Snake extends Node2D

const snake_part_scene : PackedScene = preload("res://gameplay/snake_part.tscn")

signal consumable_utilised

var head : SnakePart
var body : Array[SnakePart]
var tail : SnakePart
var color : Color		
var bounds : Bounds

var speed: float = 2000.0
var m_TimeBetweenMoves: float = 1000.0
var m_TimeSinceLastMove: float = 0.0
var move_dir: Vector2 = Vector2.RIGHT

var points: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	head = snake_part_scene.instantiate()
	head.snake_sprite.texture = preload("res://assets/textures/snake_head.png")
	
	head.moving_dir = move_dir
	head.last_moving_dir = move_dir
	head.is_head = true
	add_child(head)
	
	var body_segment : SnakePart = snake_part_scene.instantiate()
	body_segment.snake_sprite.texture = SnakePart.body_texture
	
	body_segment.moving_dir = move_dir
	body_segment.last_moving_dir = move_dir
	add_child(body_segment)
	body.push_back(body_segment)
	
	tail = snake_part_scene.instantiate()
	tail.snake_sprite.texture = preload("res://assets/textures/snake_tail.png")
	
	tail.moving_dir = move_dir
	tail.last_moving_dir = move_dir
	add_child(tail)
	
	head.consumable_eaten.connect(_on_consumable_eaten)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("ui_up") and head.moving_dir != Vector2.DOWN:
		move_dir = Vector2.UP
	elif Input.is_action_just_pressed("ui_down") and head.moving_dir != Vector2.UP:
		move_dir = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left") and head.moving_dir != Vector2.RIGHT:
		move_dir = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right") and head.moving_dir != Vector2.LEFT:
		move_dir = Vector2.RIGHT
		
	if m_TimeSinceLastMove >= m_TimeBetweenMoves:
		var move_pos : Vector2 = head.position + move_dir * Globals.GRID_SIZE
		head.last_position = head.position
		head.last_moving_dir = head.moving_dir
		head.moving_dir = move_dir
		head.position = bounds.wrap_vector(move_pos)
		
		body[0].last_position = body[0].position
		body[0].last_moving_dir = body[0].moving_dir
		body[0].position = head.last_position
		body[0].moving_dir = head.last_moving_dir
		
		if head.moving_dir != body[0].moving_dir:
			body[0].snake_sprite.texture = SnakePart.turn_texture			
		else:
			body[0].snake_sprite.texture = SnakePart.body_texture
		body[0].calculate_orientation(head.moving_dir)
		
		
		for i in range(1, body.size()):
			body[i].last_position = body[i].position
			body[i].last_moving_dir = body[i].moving_dir
			body[i].position = body[i-1].last_position
			body[i].moving_dir = body[i-1].last_moving_dir
			
			if body[i-1].moving_dir != body[i].moving_dir:
				body[i].snake_sprite.texture = SnakePart.turn_texture
			else:
				body[i].snake_sprite.texture = SnakePart.body_texture
			body[i].calculate_orientation(body[i-1].moving_dir)
			
		tail.last_position = tail.position
		tail.last_moving_dir = tail.moving_dir
		tail.position = body[body.size()-1].last_position
		tail.moving_dir = body[body.size()-1].moving_dir
		
		m_TimeSinceLastMove = 0.0
	else:
		m_TimeSinceLastMove += speed * delta
		
func _on_consumable_eaten(type, value):
	if type == Globals.CONSUMABLE_TYPE.BASIC:
		var new_body_segment : SnakePart = snake_part_scene.instantiate()
		new_body_segment.snake_sprite.texture = SnakePart.body_texture
		new_body_segment.snake_sprite.modulate = color
		print(color)
		new_body_segment.last_position = tail.position
		new_body_segment.position = body[body.size()-1].position - body[body.size()-1].moving_dir * Globals.GRID_SIZE
		new_body_segment.moving_dir = body[body.size()-1].moving_dir
		new_body_segment.last_moving_dir = tail.moving_dir
		add_child(new_body_segment)
		body.push_back(new_body_segment)
		
		tail.last_position = tail.position
		tail.last_moving_dir = tail.moving_dir
		tail.position = tail.position - tail.moving_dir * Globals.GRID_SIZE
		tail.moving_dir = body[body.size()-1].moving_dir
		
	consumable_utilised.emit(type, value)

func set_color(value):
	color = value
	head.snake_sprite.modulate = value
	for snake_segment in body:
		snake_segment.snake_sprite.modulate = value
		
	tail.snake_sprite.modulate = value
	
func set_snake_position(value):
	head.position = value
	body[0].position = head.position - head.moving_dir * Globals.GRID_SIZE
	tail.position = body[0].position - body[0].moving_dir * Globals.GRID_SIZE
