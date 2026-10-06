extends Node2D

@onready var player_inventory: Inventory = preload("res://features/player/player_inventory.tres")
@onready var initial_mission: Mission = preload("res://features/missions/data/initial_mission.tres")
@onready var map: Map = $Map
@onready var mission_ui: MissionUI = $GameUI/Control/MissionUI
@onready var fuel_ui: FuelUI = $GameUI/Control/FuelUI
@onready var jetpack: Jetpack = $Player/Jetpack
@onready var coords_ui: CoordsUI = $GameUI/Control/CoordsUI
@onready var layer1: TileMapLayer = $Map/PlanetLayers
@onready var player: Player = $Player
@onready var background: Node2D = $Background
@onready var game_ui: CanvasLayer = $GameUI


var is_scene_changing: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	fuel_ui.set_jetpack(jetpack)
	if initial_mission and initial_mission.items.size() >= 2:
		initial_mission.items[0].set_progress(0)
		initial_mission.items[1].set_progress(0)


	mission_ui.display()
	EventBus.request_start_dialogue_sequence.emit(load("res://features/dialogue/data/test.tres"))


func _on_player_mined_block(tilemap_coords: Vector2i, damage: float) -> void:
	if is_scene_changing: return
	map.damage_tile(tilemap_coords, damage) 

func _on_map_ore_block_destructed(ore: InventoryItem) -> void:
	if is_scene_changing: return
	player_inventory.add_item(ore, 1)
	if ore.name == "Coal":
		initial_mission.items[0].set_progress(initial_mission.items[0].progress + 1)
	elif ore.name == "Iron":
		initial_mission.items[1].set_progress(initial_mission.items[1].progress + 1)
		
	if initial_mission.is_completed() and not is_scene_changing:
		is_scene_changing = true
		get_tree().paused = false 
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _process(delta: float) -> void:
	if not get_tree().paused: 
		if layer1 and player:
			var relative_pos := layer1.to_local(player.global_position)
			var current_pos := layer1.local_to_map(relative_pos)
			coords_ui.update_text(current_pos.x, current_pos.y)
	
	if Input.is_action_just_pressed("PauseGame"):
		EventBus.request_open_menu.emit(EventBus.MenuType.PAUSE)

func _physics_process(delta: float) -> void:
	map.load_chunks_by_position(player.position, 4)
