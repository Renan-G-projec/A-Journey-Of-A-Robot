# Ad Maiorem Dei Gloriam!
extends Control

func _on_start_game_button_pressed() -> void:
	SceneManager.change_scene_to_file_with_loading("res://scenes/main_game.tscn", EventBus.chunk_loaded, 4)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
