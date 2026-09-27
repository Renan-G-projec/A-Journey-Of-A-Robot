# Ad Maiorem Dei Gloriam!
@tool
class_name TechtreeNode
extends Button

@export var upgrade_name: String
@export_multiline() var upgrade_description: String
@export var unlocked: bool

@export var player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres") as Inventory
@export var all_tech_cost: Dictionary[String, Dictionary] = {
	"Root":{ 
		"coal": 0,
		"iron": 0,
		"copper": 0,	
	},
	"drill_stage1":{
		"coal": 5,
		"iron": 5,
		"copper": 0,
	}, 
	"furnance_stage1":{
		"coal": 5,
		"iron": 5,
		"copper": 0,
	}
}

@export var cost: Dictionary[String, int] = {}

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
	if not toggled_on:
		return
	if unlocked:
		return	

	upgrade_name = name
	cost = all_tech_cost[upgrade_name]

	for item_name in cost:
		var required_amount: int = cost[item_name]
		
		if item > player_inventory.get_item(item): return 
		
		unlocked = true
			
	if unlocked: 
		for key: InventoryItem in cost:
			player_inventory.remove_item(key, cost[key])
	
	
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
	
	for key: InventoryItem in cost:
		string += "    - %d %s.\n" % [cost[key], key]
	
	return string
