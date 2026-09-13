extends Node2D

@onready var map: Map = $Map
@onready var resource_ui: Control = $GameUI/ResourceUI

func _on_player_fuel_changed(new_fuel: float) -> void:
    resource_ui.set_fuel(new_fuel)


func _on_player_mined_block(tilemap_coords: Vector2i, damage: float) -> void:
    map.damage_tile(tilemap_coords, damage)
