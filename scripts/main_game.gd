extends Node2D

@onready var player_inventory: Inventory = preload("res://resources/player_inventory.tres")
@onready var map: Map = $Map
@onready var fuel_ui: FuelUI = $GameUI/FuelUI
@onready var jetpack: Jetpack = $Player/Jetpack

func _ready() -> void:
    fuel_ui.set_jetpack(jetpack)

func _on_player_mined_block(tilemap_coords: Vector2i, damage: float) -> void:
	map.damage_tile(tilemap_coords, damage) 

func _on_map_ore_block_destructed(ore: InventoryItem) -> void:
	player_inventory.add_item(ore, 1)
