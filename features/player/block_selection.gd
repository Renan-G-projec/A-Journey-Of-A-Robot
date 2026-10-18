# Ad Maiorem Dei Gloriam!
extends HBoxContainer

enum State {
	OPENING,
	SELECTING,
	CLOSING,
	CLOSED
}
var state: State = State.CLOSED

signal selected_block(block_id: int)

var current_block: int = 1
var num_blocks: int
var max_size: Vector2
var initial_position: Vector2

var selected_block_transition_tween: Tween

func _ready() -> void:
	max_size = get_bound_minimum_size()
	initial_position = position
	num_blocks = get_child_count()
	visible = false

func _process(delta: float) -> void:
	_update_state()

func open() -> void:
	_fade_in()

func select() -> void:
	selected_block.emit(current_block)

func close() -> void:
	_fade_out()
	
func _fade_out() -> void:
	state = State.CLOSING
	
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "custom_maximum_size", Vector2(0, -1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	await tween.finished
	
	state = State.CLOSED
	visible = false

func _fade_in() -> void:
	state = State.OPENING
	
	visible = true
	scale = Vector2.ZERO
	position = Vector2.ZERO
	
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2(_calculate_block_position(current_block), initial_position.y), 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "custom_maximum_size", Vector2(max_size.x, -1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).finished
	await tween.finished
	
	state = State.SELECTING

func _sync_current_block() -> void:
	if state != State.SELECTING: return
	if selected_block_transition_tween:
		selected_block_transition_tween.kill()
	selected_block_transition_tween = create_tween()
	selected_block_transition_tween.tween_property(self, "position", Vector2(_calculate_block_position(current_block), position.y), 0.2)

func _calculate_block_position(block: int) -> float:
	const block_size: float = 16.0
	var block_separation: int = get_theme_constant("separation") as int
	var block_index: int = block - 1
	
	return -((block_size + block_separation) * block_index + block_size / 2);

func _update_state() -> void:
	match state:
		State.SELECTING:
			if Input.is_action_just_pressed("SelectLeftBlockSelectionMenu"):
				current_block -= 1
				current_block = clamp(current_block, 1, num_blocks)
				_sync_current_block()
			if Input.is_action_just_pressed("SelectRightBlockSelectionMenu"):
				current_block += 1
				current_block = clamp(current_block, 1, num_blocks)
				_sync_current_block()
			if Input.is_action_just_pressed("SelectBlockOnSelectionMenu"):
				select()
				close()
