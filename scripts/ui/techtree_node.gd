# Ad Maiorem Dei Gloriam!
@tool
class_name TechtreeNode
extends Button

@export var upgrade_name: String
@export_multiline() var upgrade_description: String
@export var unlocked: bool

@export var player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres") as Inventory
@export var cost: Inventory

@onready var player_stage_1: Button = $"."
@onready var line: Line2D = $Line2D

signal request_ui_techtree_panel(node: TechtreeNode)

func line_to_parent() -> void:
	var parent: TechtreeNode = get_parent() as TechtreeNode
	if !parent: return

	line.clear_points()
	
	line.add_point(size / 2)
	line.add_point(line.to_local(parent.global_position + parent.size / 2))
	
	line.z_index = z_index - 1

func _on_toggled(toggled_on: bool) -> void:
	return
	if !cost: return

	for item in cost.data:
		if player_inventory.get_item(item) < cost.get_item(item): return
	
	disabled = true
	player_inventory.remove_items(cost)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED && Engine.is_editor_hint():
		line_to_parent()
			
func _ready() -> void:
	set_notify_transform(true)
	line_to_parent()


func _on_pressed() -> void:
	request_ui_techtree_panel.emit(self)

func get_requirements_string() -> String:
	var string: String = "Requirements:\n"
	if !cost:
		return string + "    - Free\n"
	
	for input in cost.data:
		string += "    - %d %s.\n" % [cost.get_item(input), input.name]
	return string
