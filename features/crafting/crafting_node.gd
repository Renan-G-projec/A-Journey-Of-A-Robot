class_name CraftButton
extends Button

@export var craft_resource: CraftResource

signal request_ui_crafting_panel(node: CraftButton)
	
func _on_pressed() -> void:
	request_ui_crafting_panel.emit(self)
