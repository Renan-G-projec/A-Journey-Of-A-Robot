extends Node2D

@onready var resource_ui: Control = $GameUI/ResourceUI

func _on_player_fuel_changed(new_fuel: float) -> void:
    resource_ui.set_fuel(new_fuel)
