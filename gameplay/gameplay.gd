extends Node2D

const player_scene : PackedScene = preload("res://gameplay/player.tscn")

@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = $Spawner as Spawner

var players: Array[Player] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var player_spawn_point : Vector2 = spawner.spawn_player_position(0, 1)
	var player = player_scene.instantiate()
	player.set_bounds(bounds)
	add_child(player)
	player.set_player_position(player_spawn_point)
	player.set_color(Color.AQUA)
	player.consumable_used.connect(_on_consumable_used)
	players.push_back(player)
	
	spawner.spawn_food()


func _on_consumable_used(type, value):
	if type == Globals.CONSUMABLE_TYPE.BASIC:
		spawner.spawn_food()
