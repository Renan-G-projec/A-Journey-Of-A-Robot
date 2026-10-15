# Ad Maiorem Dei Gloriam!
extends Control

var _open_menus_stack: Array[Control] = []

func _ready() -> void:
	$Panel.visible = false;
	open()

func open() -> void:
	if $Panel.visible: return
	
	_open_menus_stack.clear();
	$Panel.visible = true
	_push_menu(%BaseMenuUI)

	Global.can_mine = false
	
func close() -> void:
	_hide_all()
	_open_menus_stack.clear();
	$Panel.visible = false
	Global.can_mine = true

func _on_tech_tree_button_pressed() -> void:
	_push_menu(%TechTreeUI)


func _on_buildings_button_pressed() -> void:
	_push_menu(%BuildingsUI)


func _on_crafting_button_pressed() -> void:
	_push_menu(%CraftingUI)
	

func _push_menu(menu: Control) -> void:
	_hide_all()
	_open_menus_stack.push_back(menu)
	_make_top_visible()
	
func _pop_menu() -> void:
	if _open_menus_stack.is_empty(): return
	_hide_all()
	_open_menus_stack.pop_back()
	
	if _open_menus_stack.is_empty(): close()
	_make_top_visible()

func _make_top_visible() -> void:
	var back_menu: Control = _open_menus_stack.back()
	if back_menu: back_menu.visible = true

func _hide_all() -> void:
	for menu in _open_menus_stack:
		menu.visible = false

func _process(delta: float) -> void:
	if visible && Input.is_action_just_pressed("ui_cancel"): _pop_menu()
