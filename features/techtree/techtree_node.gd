# Ad Maiorem Dei Gloriam!
@tool
class_name TechtreeNode
extends Button

@export var upgrade: TechtreeUpgrade

@onready var line: Line2D = $Line2D

signal request_ui_techtree_panel(node: TechtreeNode)

func line_to_parent() -> void:
	var parent: TechtreeNode = get_parent() as TechtreeNode
	if !parent: return

	line.clear_points()
	
	line.add_point(size / 2)
	line.add_point(line.to_local(parent.global_position) + parent.size / 2)
	
	line.z_index = z_index - 1
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED && Engine.is_editor_hint():
		line_to_parent()
			
func _ready() -> void:
	set_notify_transform(true)
	line_to_parent()


func _on_pressed() -> void:
	request_ui_techtree_panel.emit(self)
