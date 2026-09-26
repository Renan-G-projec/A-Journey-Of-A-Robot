# Ad Maiorem Dei Gloriam!
extends Control

@onready var icon: TextureRect = $Panel/VBoxContainer/CenterContainer/TextureRect
@onready var upgrade_name: Label = $Panel/VBoxContainer/UpgradeNameLabel
@onready var upgrade_description: Label = $Panel/VBoxContainer/DescriptionLabel
@onready var upgrade_requirements: Label = $Panel/VBoxContainer/RequirementsLabel
@onready var upgrade_button: Button = $Panel/VBoxContainer/Button

var current_node: TechtreeNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node: TechtreeNode in get_tree().get_nodes_in_group("TechtreeNode"):
		node.request_ui_techtree_panel.connect(_on_ui_techtree_panel_requested)
	var root: TechtreeNode = get_tree().get_first_node_in_group("TechtreeNode")
	root.request_ui_techtree_panel.emit(root)


func _on_ui_techtree_panel_requested(node: TechtreeNode) -> void:
	icon.texture = node.icon
	upgrade_name.text = node.upgrade_name
	upgrade_description.text = node.upgrade_description
	upgrade_requirements.text = node.get_requirements_string()

	upgrade_button.disabled = !node.unlocked
	
	current_node = node
