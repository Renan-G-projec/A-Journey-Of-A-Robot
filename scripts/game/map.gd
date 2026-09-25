# Ad Maiorem Dei Gloriam!
class_name Map 
extends Node2D

@export var player: Player
@onready var spawn: Marker2D = $MainBase/Spawn
@onready var layer: TileMapLayer = $PlanetLayer1
@onready var ore: TileMapLayer = $OreLayer1

# Ore loading
@onready var coal: InventoryItem = preload("res://resources/items/coal_ore.tres")
@onready var iron: InventoryItem = preload("res://resources/items/iron_ore.tres")
@onready var copper: InventoryItem = preload("res://resources/items/copper_ore.tres")

@export var tile_base_life: float = 100.0
var tiles_life: Dictionary[Vector2i, float] = {}
var fast_noise_lite := FastNoiseLite.new()

@onready var mainbase: MainBase = $MainBase
signal ore_block_destructed(ore: InventoryItem)

# Global Variables For Map Generation

# Controls the width + height of the world
var world_width: int = 130
var world_height: int = 30 # From the top wall, so generation goes up to y = 35 HARD CAP

# Where the map starts the generation from
var top_wall: int = 5

# Mimuimum amount of solid blocks from the top
var min_body_thickness: int = 20

# How much the spikes can extend from the min body thickness
var spike_height: int = 10

# max Y value Formula
var max_world_y: int = top_wall + min_body_thickness + spike_height

# Ore + Empty Tile Frequencys
var coal_frequency: float = 0.1
var iron_frequency: float = 0.05
var empty_tile_frequency: float = 0.3

func damage_tile(tile: Vector2i, damage: float) -> void:
	var life: float = tiles_life.get_or_add(tile, tile_base_life)
	if life - damage <= 0:
		var mined_ore: InventoryItem = get_ore_at_coord(tile)
		if mined_ore:
			ore_block_destructed.emit(mined_ore)
			ore.erase_cell(tile)
		destroy_tile(tile)
	else:
		tiles_life[tile] -= damage

func destroy_tile(tile: Vector2i) -> void:
	layer.set_cells_terrain_connect([tile], 0, -1)
	tiles_life.erase(tile)

# Settings stuff
func _ready() -> void:
	fast_noise_lite.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	fast_noise_lite.frequency = 0.3
	fast_noise_lite.seed = randi()
	layer.clear()
	generateMap()
	if player and spawn:
		player.global_position = spawn.global_position
		mainbase.global_position = spawn.global_position

# The root function, which starts the game
func generateMap() -> void:

	var tiles_placed: int = generateTile()
	var updated_tiles_placed: int = removeTiles(tiles_placed)
	generateOre(updated_tiles_placed)

# Generates the Map Tiles
func generateTile() -> int:

	var tiles_to_place: Array[Vector2i] = []

	for x in range(world_width/(-2)+55, world_width/(2)-55):

		var current_top: int = top_wall
		var bottom_noise := fast_noise_lite.get_noise_1d((x*25)+500)
		var current_bottom: int = top_wall + min_body_thickness + int(bottom_noise * spike_height)

		for y in range(current_top, current_bottom):
			tiles_to_place.push_back(Vector2i(x, y))

	for x in range (world_width/(-2)+25, world_width/(-2)+55):

		var current_top: int = top_wall + int(14 * fast_noise_lite.get_noise_1d(x*0.05))
		var bottom_noise := fast_noise_lite.get_noise_1d((x*25)+500)
		var current_bottom: int = top_wall + min_body_thickness + int(bottom_noise * spike_height)

		for y in range(current_top, current_bottom):
			tiles_to_place.push_back(Vector2i(x, y))

	for x in range (world_width/(-2), world_width/(-2)+25):

		var current_top: int = top_wall + int(28 * fast_noise_lite.get_noise_1d(x*0.05))
		var bottom_noise := fast_noise_lite.get_noise_1d((x*25)+500)
		var current_bottom: int = top_wall + min_body_thickness + int(bottom_noise * spike_height)

		for y in range(current_top, current_bottom):
			tiles_to_place.push_back(Vector2i(x, y))

	for x in range (world_width/(2)-55, world_width/(2)-25):

		var current_top: int = top_wall + int(14 * fast_noise_lite.get_noise_1d(x*0.05))
		var bottom_noise := fast_noise_lite.get_noise_1d((x*25)+500)
		var current_bottom: int = top_wall + min_body_thickness + int(bottom_noise * spike_height)

		for y in range(current_top, current_bottom):
			tiles_to_place.push_back(Vector2i(x, y))

	for x in range (world_width/(2)-25, world_width/(2)):

		var current_top: int = top_wall + int(20 * fast_noise_lite.get_noise_1d(x*0.05))
		var bottom_noise := fast_noise_lite.get_noise_1d((x*25)+500)
		var current_bottom: int = top_wall + min_body_thickness + int(bottom_noise * spike_height)

		for y in range(current_top, current_bottom):
			tiles_to_place.push_back(Vector2i(x, y))

	layer.set_cells_terrain_connect(tiles_to_place, 0, 0)

	var tiles_placed: int = tiles_to_place.size()

	print("Total tiles placed: ", tiles_placed)
	return tiles_placed

# Get the data ready, before calling placeOres
func generateOre(updated_tiles_placed: int) -> void:

	print("generateOre")
	print("tiles_placed: ", updated_tiles_placed)

	var coal_tiles: int = roundi(updated_tiles_placed * coal_frequency)
	var iron_tiles: int = roundi(updated_tiles_placed * iron_frequency)
	print("Coal Tiles: ", coal_tiles)
	print("Iron Tiles: ", iron_tiles)

	var valid_tiles: Array[Vector2i] = []
	for x in range(world_width/(-2)+55, world_width/(2)-55):
		for y in range(top_wall + 3, max_world_y):
			var coord := Vector2i(x, y)
			if layer.get_cell_source_id(coord) != -1 and ore.get_cell_source_id(coord) == -1:
				valid_tiles.push_back(coord)

	for x in range(world_width/(-2), world_width/(-2)+55):
		for y in range(top_wall, max_world_y):
			var coord := Vector2i(x, y)
			if layer.get_cell_source_id(coord) != -1 and ore.get_cell_source_id(coord) == -1:
				valid_tiles.push_back(coord)

	for x in range(world_width/(2)-55, world_width/(+2)):
		for y in range(top_wall, max_world_y):
			var coord := Vector2i(x, y)
			if layer.get_cell_source_id(coord) != -1 and ore.get_cell_source_id(coord) == -1:
				valid_tiles.push_back(coord)

	valid_tiles.shuffle()

	placeOres(coal_tiles, Vector2i(0,0), valid_tiles)
	placeOres(iron_tiles, Vector2i(1,0), valid_tiles)

# Actually Places The Ores on The Map
func placeOres(ore_tiles: int, index: Vector2i, valid_tiles: Array[Vector2i]) -> void:
	print("PlaceOres")
	var placed := 0
	while placed < ore_tiles and valid_tiles.size() > 0:
		var target_coord: Vector2i = valid_tiles.pop_back()
		ore.set_cell(target_coord, 1, index)
		placed += 1

# Creates openings in the map, to make it feel unstable
func removeTiles(tiles_placed: int) -> int:
	var tiles_removed: int = 0

	for x in range(world_width/(-2)+55, world_width/(2)-55):
		for y in range(top_wall + 3, max_world_y):
			var coords := Vector2i(x, y)

			if layer.get_cell_source_id(coords) != -1:
				var noise_val := fast_noise_lite.get_noise_2d(x, y)

				if noise_val > empty_tile_frequency:
					layer.set_cells_terrain_connect([coords], 0, -1)
					tiles_removed = tiles_removed + 1
				else:
					continue
			else:
				continue

	for x in range((world_width/-2), (world_width/-2)+55):
		for y in range(top_wall, max_world_y):
			var coords := Vector2i(x, y)

			if layer.get_cell_source_id(coords) != -1:
				var noise_val := fast_noise_lite.get_noise_2d(x, y)

				if noise_val > empty_tile_frequency:
					layer.set_cells_terrain_connect([coords], 0, -1)
					tiles_removed = tiles_removed + 1
				else:
					continue
			else:
				continue

	for x in range((world_width/2)-55, (world_width/2)):
		for y in range(top_wall, max_world_y):
			var coords := Vector2i(x, y)

			if layer.get_cell_source_id(coords) != -1:
				var noise_val := fast_noise_lite.get_noise_2d(x, y)

				if noise_val > empty_tile_frequency:
					layer.set_cells_terrain_connect([coords], 0, -1)
					tiles_removed = tiles_removed + 1
				else:
					continue
			else:
				continue

	var updated_tiles_placed := tiles_placed - tiles_removed
	return updated_tiles_placed

func get_ore_at_coord(local_map_coords: Vector2i) -> InventoryItem:
	var ore_id: Vector2i = ore.get_cell_atlas_coords(local_map_coords)
	match ore_id.x:
		0:
			return coal
		1:
			return iron
		2:
			return copper
	return null
