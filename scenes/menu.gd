extends Node2D

@onready var camera: Camera2D = $Background/Camera2D

@export var background_speed: float = 200

func _physics_process(delta: float) -> void:
	camera.position.x += background_speed * delta
	
func _on_start_game_button_pressed() -> void:
	SceneManager.change_scene_to_file_with_loading("res://scenes/main_game.tscn", EventBus.chunk_loaded, 4)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
