# Ad Maiorem Dei Gloriam!
extends AnimatedSprite2D

@onready var tween: Tween = create_tween()

func _input(event: InputEvent) -> void:
	var mouse_event := event as InputEventMouse
	if !mouse_event: return
	
	if mouse_event is InputEventMouseButton: play()

func _on_animation_finished() -> void:
	SceneManager.change_scene_to_file_with_loading("res://scenes/main_game.tscn", EventBus.chunk_loaded, 4)

func _on_area_2d_mouse_entered() -> void:
	if (tween && tween.is_valid()) && tween.is_running(): return
	
	tween.kill()
	scale = Vector2(0.8, 1.2)
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_QUAD)
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
