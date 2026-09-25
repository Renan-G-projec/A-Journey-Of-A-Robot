# Ad Maiorem Dei Gloriam!
extends Control

func _on_inventory_button_pressed() -> void:
	EventBus.request_open_menu.emit(EventBus.MenuType.PAUSE)


func _on_tech_tree_button_pressed() -> void:
	EventBus.request_open_menu.emit(EventBus.MenuType.TECH_TREE)


func _on_buildings_button_pressed() -> void:
	EventBus.request_open_menu.emit(EventBus.MenuType.PAUSE)


func _on_crafting_button_pressed() -> void:
	EventBus.request_open_menu.emit(EventBus.MenuType.PAUSE)
