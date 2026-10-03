class_name CraftingNode
extends Button

@export var upgrade: CraftingUpgrade

signal request_ui_crafting_panel(node: CraftingNode)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_notify_transform(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_pressed() -> void:
	request_ui_crafting_panel.emit(self)
