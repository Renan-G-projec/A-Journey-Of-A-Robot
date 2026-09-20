extends Node2D

@onready var player_inventory: Inventory = preload("res://resources/player_inventory.tres")
@onready var initial_mission: Mission = preload("res://resources/initial_mission.tres")
@onready var map: Map = $Map
@onready var mission_ui: MissionUI = $GameUI/MissionUI
@onready var fuel_ui: FuelUI = $GameUI/FuelUI
@onready var jetpack: Jetpack = $Player/Jetpack

func _ready() -> void:
	fuel_ui.set_jetpack(jetpack)
	mission_ui.display()

func _on_player_mined_block(tilemap_coords: Vector2i, damage: float) -> void:
	map.damage_tile(tilemap_coords, damage) 

func _on_map_ore_block_destructed(ore: InventoryItem) -> void:
	player_inventory.add_item(ore, 1)
	if ore.name == "Coal":
		initial_mission.items[0].set_progress(initial_mission.items[0].progress + 1)
	elif ore.name == "Iron":
		initial_mission.items[1].set_progress(initial_mission.items[1].progress + 1)
		
	if initial_mission.is_completed():
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
