extends Node2D

const player_scene : PackedScene = preload("res://gameplay/player.tscn")
const pause_menu_scene : PackedScene = preload("res://menus/pause_menu.tscn")

@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = $Spawner as Spawner
@onready var hud: HUD = %HUD as HUD
var players: Array[Player] = []

var pause_menu : PauseMenu
var food : Food

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var player_spawn_point : Vector2 = spawner.spawn_player_position(0, 1)
	var player = player_scene.instantiate()
	player.set_bounds(bounds)
	add_child(player)
	player.set_player_position(player_spawn_point)
	player.set_color(Globals.player_color)
	
	player.consumable_used.connect(_on_consumable_used)
	players.push_back(player)
	
	food = spawner.spawn_food()
	food.regenerate_food.connect(_on_regenerate_food)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game() 

func _on_consumable_used(type, value, points):
	hud.update_score(points)
		
func _on_regenerate_food():
	food = spawner.spawn_food()
	food.regenerate_food.connect(_on_regenerate_food)
		
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()
		
func pause_game() -> void:
	if not pause_menu:
		pause_menu = pause_menu_scene.instantiate() as PauseMenu
		add_child(pause_menu)
