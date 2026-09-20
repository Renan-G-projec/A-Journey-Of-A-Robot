# Ad Maiorem Dei Gloriam!
class_name MissionUI
extends RichTextLabel

@export var text_velocity: float = 0.02
@export var growing_velocity: float = 0.1
var text_timer: float = text_velocity
var current_char: int = 0
var typing: bool = false
var growing: bool = false

@onready var initial_scale_x: float = scale.x

func _ready() -> void:
	scale.x = 0

func display(mission_text: String = text) -> void:
	growing = true
	current_char = 0
	scale.x = 0
	text = mission_text
	visible_characters = 0
	text_timer = text_velocity
	
	queue_redraw()

func _process(delta: float) -> void:
	if growing:
		scale.x = lerpf(scale.x, initial_scale_x, growing_velocity)
		if scale.x > initial_scale_x - 0.01:
			growing = false
			typing = true

	if typing:
		text_timer -= delta
		if text_timer <= 0.0:
			text_timer = text_velocity
			visible_characters += 1
			if visible_characters >= text.length():
				typing = false
