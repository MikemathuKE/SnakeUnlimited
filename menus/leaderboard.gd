class_name Leaderboard extends Control

@onready var data_table: GridContainer = %DataTable
@onready var lbl_disconnected_leaderboard: Label = %LblDisconnectedLeaderboard

const start_menu_scene : PackedScene = preload("res://menus/start_menu.tscn")

var table_info : Dictionary = {}
var networking : Networking = Networking.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lbl_disconnected_leaderboard.visible = false
	networking.get_scores(0)
	add_child(networking)
	networking.retrieve_scores.connect(_on_scores_retrieved)
	networking.failed_to_connect.connect(_on_failed_connection)

func _on_tab_bar_tab_changed(tab: int) -> void:
	networking.get_scores(tab)

func _on_scores_retrieved(data: Dictionary):
	table_info = data
	print("Scores Retrieved")
	draw_table()
	
func draw_table():
	
	# Remove Existing Children
	for child in data_table.get_children():
		child.queue_free()
		
	print(table_info)
	
	# Add Other Children
	var position = 1
	for key in table_info.keys():
		if key != "size":
			var lbl_user = Label.new()
			lbl_user.text = table_info[key]['username']
			lbl_user.custom_minimum_size.x = 200
			lbl_user.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			if position == 1:
				lbl_user.add_theme_color_override("font_color", Color.LIGHT_YELLOW)
			data_table.add_child(lbl_user)
			
			var lbl_score = Label.new()
			lbl_score.text = table_info[key]['score']
			lbl_score.custom_minimum_size.x = 200
			lbl_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			if position == 1:
				lbl_score.add_theme_color_override("font_color", Color.LIGHT_YELLOW)
			data_table.add_child(lbl_score)
			
			position += 1


func _on_btn_back_pressed() -> void:
	queue_free()
	
func _on_failed_connection() -> void:
	lbl_disconnected_leaderboard.visible = true
