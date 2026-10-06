# Ad Maiorem Dei Gloriam!
extends Control

@onready var icon: TextureRect = $Panel/VBoxContainer/CenterContainer/TextureRect
@onready var upgrade_name: Label = $Panel/VBoxContainer/UpgradeNameLabel
@onready var upgrade_description: Label = $Panel/VBoxContainer/DescriptionLabel
@onready var upgrade_requirements: Label = $Panel/VBoxContainer/RequirementsLabel
@onready var upgrade_button: Button = $Panel/VBoxContainer/UpgradeButton

@export var current_player_inventory: Inventory = preload("res://features/player/player_inventory.tres")
var current_node: TechtreeNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for nodes: TechtreeNode in get_tree().get_nodes_in_group("TechtreeNode"):
		nodes.request_ui_techtree_panel.connect(_on_ui_techtree_panel_requested)
	var root: TechtreeNode = get_tree().get_first_node_in_group("TechtreeNode")
	root.request_ui_techtree_panel.emit(root)

func _on_ui_techtree_panel_requested(node: TechtreeNode) -> void:
	icon.texture = node.icon
	upgrade_name.text = node.upgrade.name
	upgrade_description.text = node.upgrade.description
	upgrade_requirements.text = node.upgrade.get_requirements_string()

	upgrade_button.disabled = TechtreeManager.has_upgrade(node.upgrade) || !current_player_inventory.has_items(node.upgrade.cost)
	
	current_node = node

func _on_upgrade_button_pressed() -> void:
	if TechtreeManager.has_upgrade(current_node.upgrade) || !current_player_inventory.has_items(current_node.upgrade.cost): 
		return
	current_player_inventory.remove_items(current_node.upgrade.cost)
	upgrade_button.disabled = true
	TechtreeManager.add_upgrade(current_node.upgrade)
