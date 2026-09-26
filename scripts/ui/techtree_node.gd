# Ad Maiorem Dei Gloriam!
@tool
class_name TechtreeNode
extends Button

@export var upgrade_name: String
@export var upgrade_description: String

@onready var player_stage_1: Button = $"."
@onready var line: Line2D = $Line2D

@export var player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres") as Inventory

@export var cost: Inventory

func line_to_parent() -> void:
	var parent: TechtreeNode = get_parent() as TechtreeNode
	if !parent: return

	line.clear_points()
	
	line.add_point(size / 2)
	line.add_point(line.to_local(parent.global_position + parent.size / 2))

func _on_toggled(toggled_on: bool) -> void:
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
