# Ad Maiorem Dei Gloriam!
extends Control

var _open_menus_stack: Array[Control] = []

func open() -> void:
	_push_menu(%BaseMenuUI)

func _on_tech_tree_button_pressed() -> void:
	_push_menu(%TechTreeUI)


func _on_buildings_button_pressed() -> void:
	_push_menu(%BuildingsUI)


func _on_crafting_button_pressed() -> void:
	_push_menu(%CraftingUI)
	

func _push_menu(menu: Control) -> void:
	menu.visible = true
	if !_open_menus_stack.is_empty(): _open_menus_stack.back().visible = false
	_open_menus_stack.push_back(menu)
	
func _pop_menu() -> void:
	_open_menus_stack.back().visible = false
	_open_menus_stack.pop_back()
	if _open_menus_stack.is_empty(): EventBus.request_close_menu.emit()
	else: _open_menus_stack.back().visible = true

func _process(delta: float) -> void:
	if visible && Input.is_action_just_pressed("ui_cancel"): _pop_menu()
