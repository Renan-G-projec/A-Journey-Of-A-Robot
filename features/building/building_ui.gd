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

signal enter_build_mode(building: PackedScene)
signal exit_build_mode()

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
	if node.building_resource.stock >= 1:
		upgrade_button.disabled = false
	else:
		upgrade_button.disabled = true
	#craft = BuildingManger.list_prerequisties(node.building_resource)
	#print("CRAFT" , craft)
	#print(!BuildingManger.are_prerequisites_met_for_building(current_node.building_resource))
	#print(node.upgrade.amount[craft] >= 1)
	#
	##upgrade_button.disabled = !BuildingManger.are_prerequisites_met_for_building(current_node.building_resource) and  node.upgrade.amount[craft] >= 1
	#

func _process(delta: float) -> void:
	if !is_building: return
	var current_camera := get_viewport().get_camera_2d()
	if Input.is_action_just_pressed("BuildingModeGoUp"): current_camera.position.y += 16
	if Input.is_action_just_pressed("BuildingModeGoUp"): current_camera.position.y -= 16
	if Input.is_action_just_pressed("BuildingModeGoRight"): current_camera.position.x += 16
	if Input.is_action_just_pressed("BuildingModeGoLeft"): current_camera.position.x -= 16
	if Input.is_action_just_pressed("ui_cancel"): 
		is_building = false
		exit_build_mode.emit()
		
		current_camera.get_child(0).queue_free()
		current_camera.position = Vector2.ZERO
	
func _on_upgrade_button_pressed() -> void:
	BuildingManger.remove_stock(current_node.building_resource, 1)
	BuildingManger.sync_stock(current_node.building_resource)
	enter_build_mode.emit(current_node.building_resource.building_scene)
	
	var current_camera := get_viewport().get_camera_2d()
	var new_building: Node2D = current_node.building_resource.building_scene.instantiate()
	new_building.modulate.a = 100
	Global.can_move = false
	is_building = true
	current_camera.add_child(new_building)
