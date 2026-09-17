extends Node2D

@onready var map: Map = $Map
@onready var fuel_ui: Control = $GameUI/FuelUI

func _on_player_fuel_changed(new_fuel: float) -> void:
    fuel_ui.set_fuel(new_fuel)

func _on_player_mined_block(tilemap_coords: Vector2i, damage: float) -> void:
    map.damage_tile(tilemap_coords, damage)

func _on_inventory_changed(item: InventoryItem, new_qtd: int) -> void:
    print("ITEM ADDED")
