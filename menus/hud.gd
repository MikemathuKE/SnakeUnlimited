class_name HUD extends CanvasLayer

@onready var lbl_points: Label = %LblPoints
@onready var lbl_high_score: Label = %LblHighScore

func _ready() -> void:
	lbl_high_score.text = "High Score: " + str(Globals.save_data.high_score)

func update_score(n: int) -> void:
	lbl_points.text = "Score: " + str(n)
	
