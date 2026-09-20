# Ad Maiorem Dei Gloriam!
extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect
@onready var mission: MissionUI = $MissionUI
var in_transition: bool = false

# This script will just adjust the UI zoom accordingly with the camera.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition_rect.color.a = 1.0
	in_transition = true

func _process(delta: float) -> void:
	if in_transition:
		transition_rect.color.a = lerp(transition_rect.color.a, 0.0, 0.1)
		if (transition_rect.color.a < 0.03):
			in_transition = false
			transition_rect.color.a = 0
