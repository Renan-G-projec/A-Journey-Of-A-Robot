# Ad Maiorem Dei Gloriam!
extends Label
class_name CoordsUI 


func update_text(x: int, y: int) -> void:
	text = "Coordinates: X: %d, Y: %d" % [x, y]
