# Ad Maiorem Dei Gloriam!
extends HBoxContainer

signal selected_block_changed(block_id)

@export var current_block: int = 1
var num_blocks: int
var active: bool = false
var max_size: Vector2

func _ready() -> void:
	max_size = get_bound_minimum_size()
	num_blocks = get_child_count()

func _process(delta: float) -> void:
	if !active: return
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
	

func open() -> void:
	active = true
	_fade_in()

func select() -> void:
	active = false
	selected_block_changed.emit(current_block)
	_fade_out()

func toggle() -> void:
	if active:
		select()
	else:
		open()
	
func _fade_out() -> void:
	var tween := create_tween()
	await tween.tween_property(self, "custom_maximum_size", Vector2(0, -1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	visible = false

func _fade_in() -> void:
	visible = true
	var tween := create_tween()
	tween.tween_property(self, "custom_maximum_size", Vector2(max_size.x, -1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

func _sync_current_block() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(_calculate_block_position(current_block), position.y), 0.2)

func _calculate_block_position(block: int) -> float:
	const block_size: float = 16.0
	var block_separation: int = get_theme_constant("separation") as int
	var block_index: int = block - 1
	
	return -((block_size + block_separation) * block_index + block_size / 2);
