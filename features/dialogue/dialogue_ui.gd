# Ad Maiorem Dei Gloriam!
class_name DialogueUI
extends Control

var _current_text_length: int = 0
var _is_typing: bool = false
var _current_dialogue_sequence: DialogueSequence
var _current_dialogue_index: int = 0

func load_dialogue_sequence(sequence: DialogueSequence) -> void:
	_current_dialogue_sequence = sequence
	_current_dialogue_index = 0
	var current_dialogue: Dialogue = _pop_dialogue()
	_display_dialogue(current_dialogue.icon, current_dialogue.dialogue)

func _ready() -> void:
	load_dialogue_sequence(load("res://features/dialogue/data/test.tres"))

func _display_dialogue(icon: Texture2D, text: String) -> void:
	if !visible:
		_show()
	%Icon.texture = icon
	%Dialogue.text = text
	
	_current_text_length = text.length()
	_is_typing = true
	%Dialogue.visible_characters = 0
	%Timer.start()

func _process(delta: float) -> void:
	if visible && Input.is_action_just_pressed("ui_accept"):
		if !_is_typing:
			var current_dialogue: Dialogue = _pop_dialogue()
			if !current_dialogue:
				_hide()
			else:
				_display_dialogue(current_dialogue.icon, current_dialogue.dialogue)
		else:
			%Dialogue.visible_characters += 4

func _on_timer_timeout() -> void:
	%Dialogue.visible_characters += 1
	if %Dialogue.visible_characters > _current_text_length:
		_is_typing = false
		%Timer.stop()

func _pop_dialogue() -> Dialogue:
	if _current_dialogue_sequence.sequence.size() <= _current_dialogue_index:
		return null
	_current_dialogue_index += 1
	return _current_dialogue_sequence.sequence[_current_dialogue_index - 1]
	
func _hide() -> void:
	visible = false

func _show() -> void:
	visible = true
