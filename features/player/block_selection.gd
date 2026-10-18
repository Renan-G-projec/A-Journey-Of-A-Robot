# Ad Maiorem Dei Gloriam!
extends HBoxContainer

signal selected_block_changed(block_id)

var active: bool = false

func open() -> void:
	active = true

func select() -> void:
	pass
