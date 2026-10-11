# Ad Maiorem Dei Gloriam!
extends AnimatedSprite2D

var _clicked: bool = false

func _input(event: InputEvent) -> void:
	if _clicked: return
	var mouse_event := event as InputEventMouse
	if !mouse_event: return
	
	if mouse_event is InputEventMouseButton: 
		_clicked = true
		_bounce(Vector2(1.4, 0.6))
		await create_tween().tween_property($"../Camera2D", "zoom", Vector2(1.7, 1.7), 0.15).set_trans(Tween.TRANS_CUBIC).finished
		create_tween().tween_property($"../Camera2D", "zoom", Vector2(5.0, 5.0), 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		$AudioStreamPlayer2.pitch_scale = 1.0
		$AudioStreamPlayer2.play()
		SoundManager.start_music()
		play()

func _on_animation_finished() -> void:
	SceneManager.change_scene_to_file_with_loading("res://scenes/main_game.tscn", EventBus.chunk_loaded, 4)

func _on_area_2d_mouse_entered() -> void:
	_bounce()
	$AudioStreamPlayer.pitch_scale = 1 + 0.5 * randf()
	$AudioStreamPlayer.play()
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	$AudioStreamPlayer.pitch_scale = 1 - 0.5 * randf()
	$AudioStreamPlayer.play()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _bounce(_scale: Vector2 = Vector2(0.8, 1.2)) -> void:
	var tween := create_tween()
	scale = _scale
	tween.tween_property(self, "scale", Vector2.ONE * 0.8, 0.1).set_trans(Tween.TRANS_QUAD)
