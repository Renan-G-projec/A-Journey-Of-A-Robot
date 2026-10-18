extends Control

@onready var icon: TextureRect = %Icon

@onready var buildings: Control = %Buildings
@onready var upgrade_name: Label = %BuildName
@onready var upgrade_description: Label = %DescriptionLabel
@onready var upgrade_requirements: Label = %RequirementsLabel
@onready var upgrade_button: Button = %BuildButton

# Called when the node enters the scene tree for the first time.
var current_node: BuildingButton
var new_name: String
var craft: CraftResource
var is_building: bool = false

func _ready() -> void:
	for nodes: BuildingButton in get_tree().get_nodes_in_group("BuildingButtons"):
		nodes.request_ui_building_panel.connect(request_ui_building_panel)
	var root: BuildingButton = get_tree().get_first_node_in_group("BuildingButtons")
	root.request_ui_building_panel.emit(root)

func request_ui_building_panel(node: BuildingButton) -> void:
	current_node = node 
	icon.texture = node.icon
	upgrade_name.text = node.building_resource.name
	upgrade_description.text = node.building_resource.description
	upgrade_requirements.text = node.building_resource.get_requirements_string()
	BuildingManger.sync_stock(node.building_resource)
	print("node.building_resource.stock")
	if node.building_resource.stock >= 1:
		upgrade_button.disabled = false
	else:
		upgrade_button.disabled = true
	
func _on_upgrade_button_pressed() -> void:
	BuildingManger.remove_stock(current_node.building_resource, 1)
	BuildingManger.sync_stock(current_node.building_resource)
	
	EventBus.enter_build_mode.emit(current_node.building_resource.building_scene)
