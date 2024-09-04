class_name SnakePart extends Area2D

@export var snake_sprite: Sprite2D

signal consumable_eaten

var last_position: Vector2 = Vector2(32, 32)
var moving_dir: Vector2 = Vector2.RIGHT # Angle of Rotation
var last_moving_dir: Vector2 = moving_dir
var orientation: int = 1 # 1 is anticlockwise or straight , -1 is clockwise
var is_head : bool = false

static var turn_texture : Texture2D = preload("res://assets/textures/snake_body_turn.png")
static var body_texture : Texture2D = preload("res://assets/textures/snake_body.png")

func _process(delta: float) -> void:
	if moving_dir == Vector2.UP:
		snake_sprite.rotation_degrees = 0.0 * orientation
	elif moving_dir == Vector2.RIGHT:
		snake_sprite.rotation_degrees = 90.0 * orientation
	elif moving_dir == Vector2.DOWN:
		snake_sprite.rotation_degrees = 180.0 * orientation
	elif moving_dir == Vector2.LEFT:
		snake_sprite.rotation_degrees = 270.0 * orientation
	if orientation == -1:
		snake_sprite.rotation_degrees += 90
		
		# Flip vertically for sideways motions
		if moving_dir == Vector2.DOWN or moving_dir == Vector2.UP:
			snake_sprite.rotation_degrees += 180

func calculate_orientation(next_dir: Vector2):
	if moving_dir == Vector2.DOWN and next_dir == Vector2.RIGHT:
		orientation = 1
	elif moving_dir == Vector2.DOWN and next_dir == Vector2.LEFT:
		orientation = -1
	elif moving_dir == Vector2.UP and next_dir == Vector2.RIGHT:
		orientation = -1
	elif moving_dir == Vector2.UP and  next_dir == Vector2.LEFT:
		orientation = 1
	elif moving_dir == Vector2.RIGHT and next_dir == Vector2.UP:
		orientation = 1
	elif moving_dir == Vector2.RIGHT and next_dir == Vector2.DOWN:
		orientation = -1
	elif moving_dir == Vector2.LEFT and next_dir == Vector2.UP:
		orientation = -1
	elif moving_dir == Vector2.LEFT and  next_dir == Vector2.DOWN:
		orientation = 1
	else:
		orientation = 1

func _on_area_entered(area: Area2D) -> void:
	if is_head:
		if area.is_in_group("consumable"):
			var consumable : Consumable = area as Consumable
			consumable_eaten.emit(consumable.type, consumable.value)
			area.call_deferred("queue_free")
