class_name StartMenu extends CanvasLayer

const gameplay_scene : PackedScene = preload("res://gameplay/gameplay.tscn")

@onready var btn_color : ColorPickerButton = %BtnColor as ColorPickerButton
@onready var lbl_high_score: Label = %LblHighScore

func _ready() -> void:
	var high_score: int = Globals.save_data.high_score
	lbl_high_score.text = "High Score: " + str(high_score)
	btn_color.color = Color.AQUA

func _on_btn_single_player_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_btn_quit_pressed() -> void:
	get_tree().quit()

func _on_btn_color_color_changed(color: Color) -> void:
	Globals.player_color = color
