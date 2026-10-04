extends Control

@onready var icon: TextureRect = $UpgradePanel/VBoxContainer/CenterContainer/TextureRect

@onready var buildings: Control = $BuildingPanel/Buildings
@onready var upgrade_name: Label = $UpgradePanel/VBoxContainer/UpgradeNameLabel
@onready var upgrade_description: Label = $UpgradePanel/VBoxContainer/DescriptionLabel
@onready var upgrade_requirements: Label = $UpgradePanel/VBoxContainer/RequirementsLabel
@onready var upgrade_button: Button = $UpgradePanel/VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
var current_node: BuildingNode
var new_name: String
var craft: CraftingUpgrade

func _ready() -> void:
	for nodes: BuildingNode in get_tree().get_nodes_in_group("BuildingNode"):
		nodes.request_ui_building_panel.connect(request_ui_building_panel)
	var root: BuildingNode = get_tree().get_first_node_in_group("BuildingNode")
	root.request_ui_building_panel.emit(root)

func request_ui_building_panel(node: BuildingNode) -> void:
	current_node = node 
	icon.texture = node.icon
	upgrade_name.text = node.upgrade.name
	upgrade_description.text = node.upgrade.description
	upgrade_requirements.text = node.upgrade.get_requirements_string()
	craft = BuildingManger.list_prerequisties(node.upgrade)
	print("CRAFT" , craft)
	upgrade_button.disabled = !BuildingManger.are_prerequisites_met_for_building(current_node.upgrade) and  node.upgrade.amount[craft] >= 1

	
func _on_upgrade_button_pressed() -> void:
	print("Upgrade Button Pressed")
	if BuildingManger.are_prerequisites_met_for_building(current_node.upgrade):
		upgrade_button.disabled = true
		print("upgrade worked")
	else:
		print("upgrade Failed")
