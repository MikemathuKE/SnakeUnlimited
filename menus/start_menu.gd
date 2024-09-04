class_name StartMenu extends CanvasLayer

const gameplay_scene : PackedScene = preload("res://gameplay/gameplay.tscn")

func _on_btn_single_player_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
