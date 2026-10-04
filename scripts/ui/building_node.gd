class_name BuildingButton
extends Button

@export var building_resource: BuildingResource

signal request_ui_building_panel(node: BuildingButton)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	print("Pressed", self)
	request_ui_building_panel.emit(self)
