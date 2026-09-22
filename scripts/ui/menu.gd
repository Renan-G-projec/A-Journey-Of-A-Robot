extends Node2D

@onready var camera: Camera2D = $Background/Camera2D
@onready var transition_rect: ColorRect = $UI/TransitionRect

@export var background_speed: float = 200
var on_transition: bool = false

func _physics_process(delta: float) -> void:
	camera.position.x += background_speed * delta
	
func _process(delta: float) -> void:
	if on_transition:
		transition_rect.color.a = lerp(transition_rect.color.a, 1.0, 0.1)
		if (transition_rect.color.a > 0.97):
			# Changes to 1 because changing scene can be delayed and the screen should not be transparent
			transition_rect.color.a = 1
			get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")
	
func _on_start_game_button_pressed() -> void:
	on_transition = true

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
