class_name HUD extends CanvasLayer

@onready var lbl_points: Label = %LblPoints
@onready var lbl_personal_best: Label = %LblPersonalBest
@onready var lbl_high_score_hud: Label = %LblHighScoreHud

func _ready() -> void:
	lbl_personal_best.text = "Personal Best: " + str(Globals.save_data.high_score)
	lbl_high_score_hud.text = "High Score: " + str(Globals.high_score)

func update_score(n: int) -> void:
	lbl_points.text = "Score: " + str(n)
	
