extends Control

@onready var icon: TextureRect = $UpgradePanel/VBoxContainer/CenterContainer/TextureRect

@onready var upgrade_name: Label = $UpgradePanel/VBoxContainer/UpgradeNameLabel
@onready var upgrade_description: Label = $UpgradePanel/VBoxContainer/DescriptionLabel
@onready var upgrade_requirements: Label = $UpgradePanel/VBoxContainer/RequirementsLabel
@onready var upgrade_button: Button = $UpgradePanel/VBoxContainer/Button

@export var current_player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres")
var current_node: CraftingNode

func _ready() -> void:
	for nodes: CraftingNode in get_tree().get_nodes_in_group("CraftingNode"):
		nodes.request_ui_crafting_panel.connect(_on_ui_crafting_panel_requested)
	var root: CraftingNode = get_tree().get_first_node_in_group("CraftingNode")
	root.request_ui_crafting_panel.emit(root)

func _on_ui_crafting_panel_requested(node: CraftingNode) -> void:
	icon.texture = node.icon
	upgrade_name.text = node.upgrade.name
	upgrade_description.text = node.upgrade.description
	upgrade_requirements.text = node.upgrade.get_requirements_string()
	upgrade_button.disabled = !current_player_inventory.has_items(node.upgrade.cost)
	
	current_node = node

func _on_upgrade_button_pressed() -> void:
	current_player_inventory.remove_items(current_node.upgrade.cost)
	upgrade_button.disabled = true
