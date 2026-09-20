class_name MainBase
extends Node2D

@onready var techtree_ui: PopupMenu = $TechTree
@onready var interact_area: Area2D = $Area2D

func _process(delta: float) -> void:
	# The area bitmask is setted to the player. So we can just check if have some as only the player have the collision layer expected to be 1
	if interact_area.has_overlapping_bodies():
		if Input.is_action_just_pressed("Interact"):
			techtree_ui.visible = !techtree_ui.visible
	else:
		techtree_ui.hide()
