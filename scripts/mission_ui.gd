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
@export var current_mission: Mission

func _ready() -> void:
	scale.x = 0

func display() -> void:
	growing = true
	current_char = 0
	scale.x = 0
	visible_characters = 0
	text_timer = text_velocity
	
	text = ""
	
	update_text()
	for item in current_mission.items:
		item.changed_progress.connect(_on_mission_item_changed_progress)
	
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

func update_text() -> void:
	text = ""
	for item in current_mission.items:
		text += item.content + " [color=lime]" + str(item.progress) + "/" + str(item.maximum) + "[/color]\n"

func _on_mission_item_changed_progress(_progress: int) -> void:
	update_text()
