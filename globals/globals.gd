extends Node2D

enum CONSUMABLE_TYPE {BASIC, BONUS}

const GRID_SIZE : int = 32

var player_color : Color = Color.AQUA

var save_data: SaveData

var game_level: int = 0

func _ready() -> void:
	save_data = SaveData.load_or_create()
