extends Control

@onready var icon: TextureRect = $UpgradePanel/VBoxContainer/CenterContainer/TextureRect

@onready var upgrade_name: Label = $UpgradePanel/VBoxContainer/UpgradeNameLabel
@onready var upgrade_description: Label = $UpgradePanel/VBoxContainer/DescriptionLabel
@onready var upgrade_requirements: Label = $UpgradePanel/VBoxContainer/RequirementsLabel
@onready var upgrade_button: Button = $UpgradePanel/VBoxContainer/Button

@export var current_player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres")


var craft_button: CraftButton
var new_name: String

func _ready() -> void:
	for nodes: CraftButton in get_tree().get_nodes_in_group("CraftButtons"):
		nodes.request_ui_crafting_panel.connect(_on_ui_crafting_panel_requested)
	var root: CraftButton = get_tree().get_first_node_in_group("CraftButtons")
	root.request_ui_crafting_panel.emit(root)

func _on_ui_crafting_panel_requested(node: CraftButton) -> void:
	craft_button = node 
	icon.texture = node.icon
	upgrade_name.text = node.craft_resource.name
	upgrade_description.text = node.craft_resource.description
	upgrade_requirements.text = node.craft_resource.get_requirements_string()
	upgrade_button.disabled = !current_player_inventory.has_items(node.craft_resource.cost) 

	
	
	
func _on_upgrade_button_pressed() -> void:
	print("Upgrade Button Pressed")
	if CraftingManger.are_prerequisites_met_for_crafting(craft_button.craft_resource):
		current_player_inventory.remove_items(craft_button.craft_resource.cost)
		CraftingManger.add_craft_resource(craft_button.craft_resource)
		print("upgrade worked")
	else:
		print("upgrade Failed")
