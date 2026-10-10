# Ad Maiorem Dei Gloriam!
extends Control

@onready var selected_ui: NinePatchRect = %SelectedUI

var _selected_button: Button:
	set(val):
		_squash_button(_selected_button, Vector2(1.1, 0.9))
		_selected_button = val
		_squash_button(_selected_button, Vector2(0.9, 1.1))
		
		selected_ui.global_position = _selected_button.global_position - Vector2(14, 0)
		
		selected_ui.size = _selected_button.size

func _ready() -> void:
	%ButtonsContainer.pivot_offset_ratio = Vector2(0.5, 0.5)
	for button: Button in %ButtonsContainer.get_children():
		button.mouse_entered.connect(_on_mouse_entered_button.bind(button))
		button.pivot_offset_ratio = Vector2(0.5, 0.5)

	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(selected_ui, "scale", Vector2(1.1, 1.1), 0.7).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(selected_ui, "scale", Vector2(1, 1), 0.7).set_trans(Tween.TRANS_QUAD)
	
	_selected_button = %StartGameButton
	
func _on_start_game_button_pressed() -> void:
	SceneManager.change_scene_to_file_with_loading("res://scenes/main_game.tscn", EventBus.chunk_loaded, 4)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _on_mouse_entered_button(button: Button) -> void:
	_selected_button = button

func _squash_button(button: Button, _scale: Vector2, time: float = 0.15) -> void:
	if !button: return
	
	button.pivot_offset_ratio = Vector2(0.5, 0.5)
	button.scale = _scale
	
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", Vector2.ONE, time).set_trans(Tween.TRANS_BOUNCE)
