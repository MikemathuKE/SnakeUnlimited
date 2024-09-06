class_name Food extends Consumable

signal regenerate_food

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type = Globals.CONSUMABLE_TYPE.BASIC

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("snake_part"):
		var snake_part : SnakePart = area as SnakePart
		regenerate_food.emit()
		queue_free()
