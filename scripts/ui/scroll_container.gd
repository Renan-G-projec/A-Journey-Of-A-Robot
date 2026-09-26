# Ad Maiorem Dei Gloriam!
extends Control

@onready var tech_tree: Control = $Techtree

var dragging: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed && get_rect().has_point(event.position)
			
	elif event is InputEventMouseMotion && dragging:
		tech_tree.position += event.relative
