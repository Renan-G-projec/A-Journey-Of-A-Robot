# Ad Maiorem Dei Gloriam!
class_name MissionUI
extends RichTextLabel

@export var text_velocity: float = 0.02

var text_timer: float = text_velocity
var current_char: int = 0
var typing: bool = false

func _ready() -> void:
	MissionManager.changed_mission.connect(_fetch_text)
	MissionManager.completed_mission.connect(_fetch_text)
	_fetch_text(MissionManager.current_mission)

func _reset() -> void:
	current_char = 0
	visible_characters = 0
	text_timer = text_velocity
	text = ""
	
	_fetch_text(MissionManager.current_mission)
	
	queue_redraw()

func _process(delta: float) -> void:
	_update_if_typing(delta)

func _update_if_typing(delta: float) -> void:
	if typing:
		text_timer -= delta
		if text_timer <= 0.0:
			text_timer = text_velocity
			visible_characters += 1
			if visible_characters >= text.length():
				typing = false

func _fetch_text(mission: Mission) -> void:
	if !MissionManager.current_mission:
		visible = false
		return
	
	visible = true
	text = MissionManager.current_mission.get_string()
