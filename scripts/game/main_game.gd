extends Node2D

@onready var player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres")
@onready var initial_mission: Mission = preload("res://resources/missions/initial_mission.tres")
@onready var map: Map = $Map
@onready var mission_ui: MissionUI = $GameUI/MissionUI
@onready var fuel_ui: FuelUI = $GameUI/FuelUI
@onready var jetpack: Jetpack = $Player/Jetpack
@onready var coords_ui: CoordsUI = $GameUI/CoordsUI
@onready var layer1: TileMapLayer = $Map/PlanetLayer1
@onready var player: Player = $Player


var techtree: bool = false

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


func _process(delta: float) -> void:

	if layer1:
		var relative_pos := layer1.to_local(player.global_position)
		var current_pos := layer1.local_to_map(relative_pos)
		coords_ui.update_text(current_pos.x, current_pos.y)
	
	if Input.is_action_just_pressed("OpenTechTree"):
		get_tree().change_scene_to_file("res://scenes/ui/techtree_scene.tscn")
