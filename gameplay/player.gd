class_name Player extends Node2D

signal consumable_used

@export var snake : Snake

var points : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snake.consumable_utilised.connect(_on_consumable_utilised)

func _on_consumable_utilised(type, value) -> void:
	points = points + value
	print(points)
	speed_up()
	consumable_used.emit(type, value)

func set_bounds(bounds) -> void:
	snake.bounds = bounds
	
func set_color(color) -> void:
	snake.set_color(color)
	
func set_player_position(value) -> void:
	snake.set_snake_position(value)

func speed_up() -> void:
	snake.speed = snake.speed + 400.0
