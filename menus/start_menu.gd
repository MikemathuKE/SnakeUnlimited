class_name StartMenu extends CanvasLayer

const gameplay_scene : PackedScene = preload("res://gameplay/gameplay.tscn")
const leader_board_scene : PackedScene = preload("res://menus/leaderboard.tscn")

@onready var btn_color : ColorPickerButton = %BtnColor as ColorPickerButton
@onready var lbl_high_score: Label = %LblHighScore

@onready var lbl_personal_best: Label = %LblPersonalBest
@onready var lbl_disconnected: Label = %LblDisconnected
@onready var lbl_loading_text: Label = %LblLoadingText

var networking : Networking = Networking.new()

func _ready() -> void:
	add_child(networking)
	lbl_disconnected.visible = false
	lbl_loading_text.visible = true
	
	var personal_best: int = Globals.save_data.high_score
	lbl_personal_best.text = "Personal Best: " + str(personal_best)
	btn_color.color = Color.AQUA
	
	networking.highest_score.connect(_on_get_highest_score)
	networking.failed_to_connect.connect(_on_connection_failed)
	networking.get_highest_score(Globals.game_level)

func _on_btn_single_player_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_btn_quit_pressed() -> void:
	get_tree().quit()

func _on_btn_color_color_changed(color: Color) -> void:
	Globals.player_color = color


func _on_level_options_item_selected(index: int) -> void:
	Globals.game_level = index
	networking.get_highest_score(index)

func _on_btn_leaderboard_pressed() -> void:
	var leaderboard : Leaderboard = leader_board_scene.instantiate()
	add_child(leaderboard)
	
func _on_get_highest_score(response: Dictionary) -> void:
	print(typeof(response) == TYPE_DICTIONARY)
	var high_score: int = int(response['highest_score'])
	
	if high_score > 0:
		lbl_high_score.text = "High Score: " + str(high_score)
		Globals.high_score = str(high_score)
		lbl_disconnected.visible = false
		lbl_loading_text.visible = false
		
func _on_connection_failed() -> void:
	lbl_disconnected.visible = true
	lbl_loading_text.visible = false
