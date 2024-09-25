class_name GameOver extends CanvasLayer

const leader_board_scene : PackedScene = preload("res://menus/leaderboard.tscn")

@onready var score_label: Label = %ScoreLabel
@onready var high_score_label: Label = %HighScoreLabel
@onready var level: Label = %Level
@onready var end_game: GridContainer = %EndGame
@onready var save_scores: GridContainer = %SaveScores
@onready var txt_username: TextEdit = %TxtUsername
@onready var btn_leaderboard: Button = %BtnLeaderboard

var networking : Networking = Networking.new()

func _ready() -> void:
	add_child(networking)

func set_score(n: int) -> void:
	score_label.text = "Final Score: " + str(n)
	
	#ToDo : High score logic and saving
	if n > Globals.save_data.high_score:
		high_score_label.visible = true
		Globals.save_data.high_score = n
		Globals.save_data.save()
		
	else:
		high_score_label.visible = false
		end_game.visible = true
		save_scores.visible = false
		btn_leaderboard.visible = true
		
	end_game.visible = false
	save_scores.visible = true
	btn_leaderboard.visible = false
	
	if Globals.game_level == 0:
		level.text = "Level: Expert!"
	elif Globals.game_level == 1:
		level.text = "Level: Normal!"
	elif Globals.game_level == 2:
		level.text = "Level: Easy!"


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false


func _on_btn_quit_pressed() -> void:
	get_tree().quit()


func _on_btn_save_score_pressed() -> void:
	networking.submit_score(Globals.save_data.high_score, txt_username.text, Globals.game_level)
	end_game.visible = true
	save_scores.visible = false
	btn_leaderboard.visible = true

func _on_btn_leaderboard_pressed() -> void:
	var leaderboard : Leaderboard = leader_board_scene.instantiate()
	add_child(leaderboard)
