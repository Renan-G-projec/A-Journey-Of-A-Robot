# Ad Maiorem Dei Gloriam!
@tool
class_name TechtreeNode
extends Button

@export var upgrade: TechtreeUpgrade

@export var extra_parents: Array[TechtreeNode] = []

var _lines: Array[Line2D] = []


@onready var line: Line2D = $Line2D

signal request_ui_techtree_panel(node: TechtreeNode)

func _get_line (i:int) -> Line2D:
	while _lines.size() <= i:
		var clone := line.duplicate() as Line2D
		add_child(clone, false, Node.INTERNAL_MODE_FRONT)
		_lines.append(clone)
	return _lines[i]

func line_to_parent() -> void:
	var targets: Array[TechtreeNode] = []
	var parent: TechtreeNode = get_parent() as TechtreeNode
	if parent: targets.append(parent)
	for p in extra_parents:
		if p and p != self: targets.append(p)
		
	for i in targets.size():
		var line = _get_line(i)
		line.clear_points()
		line.add_point(size / 2)
		line.add_point(line.to_local(targets[i].global_position) + targets[i].size / 2)
		line.z_index = z_index - 1
		
	for i in range(targets.size(), _lines.size()):
		_lines[i].clear_points()
	
	
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED && Engine.is_editor_hint():
		line_to_parent()
			
func _ready() -> void:
	set_notify_transform(true)
	_lines = [line]
	for p in extra_parents:
		if p and not p.item_rect_changed.is_connected(line_to_parent):
			p.item_rect_changed.connect(line_to_parent)
	line_to_parent()


func _on_pressed() -> void:
	request_ui_techtree_panel.emit(self)
