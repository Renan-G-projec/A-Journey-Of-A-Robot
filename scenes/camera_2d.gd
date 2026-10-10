# Ad Maiorem Dei Gloriam!
extends Camera2D

@export var mouse_follow_effect: float = 0.01

func _input(event: InputEvent) -> void:
	var mouse_input := event as InputEventMouseMotion
	if !mouse_input: return
	
	var middle_of_screen: Vector2 = get_viewport_rect().size / 2
	var mouse_delta: Vector2 = mouse_input.position - middle_of_screen
	
	position = mouse_delta * mouse_follow_effect
