extends Node2D

@onready var player_inventory: Inventory = preload("res://features/player/player_inventory.tres")
@onready var map: Map = $Map
@onready var mission_ui: MissionUI = $GameUI/Control/MissionUI
@onready var fuel_ui: FuelUI = $GameUI/Control/FuelUI
@onready var jetpack: Jetpack = $Player/Jetpack
@onready var coords_ui: CoordsUI = $GameUI/Control/CoordsUI
@onready var layer: TileMapLayer = $Map/PlanetLayers
@onready var player: Player = $Player
@onready var game_ui: CanvasLayer = $GameUI

func _ready() -> void:
	fuel_ui.set_jetpack(jetpack)
	
	if OS.has_feature("editor"): _debug_config()
	
	# Connecting the buildings menus
	EventBus.enter_build_mode.connect(enter_building_state)
	EventBus.exit_build_mode.connect(exit_building_state)
	
	player.placed_machine.connect(map.place_building)

func _on_player_mined_block(tilemap_coords: Vector2i, damage: float) -> void:
	map.damage_tile(tilemap_coords, damage) 

func _on_map_ore_block_destructed(ore: InventoryItem) -> void:
	player_inventory.add_item(ore, 1)

func _process(delta: float) -> void:
	if not get_tree().paused: 
		if layer and player:
			var relative_pos := layer.to_local(player.global_position)
			var current_pos := layer.local_to_map(relative_pos)
			coords_ui.update_text(current_pos.x, current_pos.y)
	
	if Input.is_action_just_pressed("PauseGame"):
		EventBus.request_open_menu.emit(EventBus.MenuType.PAUSE)

func _physics_process(delta: float) -> void:
	map.load_chunks_by_position(player.position, 4)

func enter_building_state(building: PackedScene) -> void:
	Global.can_move = false
	
func exit_building_state() -> void:
	Global.can_move = true

#region DEBUG
# This function is for configuring things for debug, suich as infinite inventory and stuff like that
const COAL_ORE = preload("uid://bko8wv0d2j44d")
const IRON_ORE = preload("uid://lk30ldug605k")
const COPPER_ORE = preload("uid://e21t8ysctxhb")
const COPPER_BAR = preload("uid://dofq3p1g0fv5w")
const IRON_BAR = preload("uid://dyshuulfur38h")

func _debug_config() -> void:
	assert(OS.is_debug_build())
	print("DEBUG: adding raw ores to inventory...")
	player_inventory.add_item(COAL_ORE, 999)
	player_inventory.add_item(IRON_ORE, 999)
	player_inventory.add_item(COPPER_ORE, 999)
	print("DEBUG: raw ores added to the inventory!")
	
	print("DEBUG: processed ores (bars) being added to the inventory...")
	player_inventory.add_item(IRON_BAR, 999)
	player_inventory.add_item(COPPER_BAR, 999)
	print("DEBUG: added processed ores to the inventory!")
#endregion
