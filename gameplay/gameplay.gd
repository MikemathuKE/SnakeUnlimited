extends Node2D

const player_scene : PackedScene = preload("res://gameplay/player.tscn")
const pause_menu_scene : PackedScene = preload("res://menus/pause_menu.tscn")

@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = $Spawner as Spawner
@onready var hud: HUD = %HUD as HUD

var player: Player 
var pause_menu : PauseMenu
var food : Food
var game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var player_spawn_point : Vector2 = spawner.spawn_player_position(0, 1)
	player = player_scene.instantiate()
	player.set_bounds(bounds)
	add_child(player)
	player.set_player_position(player_spawn_point)
	player.set_color(Globals.player_color)
	
	player.consumable_used.connect(_on_consumable_used)
	player.game_over.connect(_on_game_over)
	
	food = spawner.spawn_food()
	food.regenerate_food.connect(_on_regenerate_food)
	game_over = false
	print(game_over)

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
	print(game_over)
	if not pause_menu and not game_over:
		pause_menu = pause_menu_scene.instantiate() as PauseMenu
		add_child(pause_menu)
		
func _on_game_over(value) -> void:
	game_over = value
	print("game over called!")
	
