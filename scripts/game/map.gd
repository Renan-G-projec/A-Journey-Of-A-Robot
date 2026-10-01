# Ad Maiorem Dei Gloriam!
class_name Map 
extends Node2D

# Number of layers
const NUMBER_OF_LAYERS := 3
const CHUNK_WIDTH := 16
const PLANET_BOTTOM := CHUNK_WIDTH * NUMBER_OF_LAYERS + 10

# Map Generation configs
@export_range(0.05, 0.95, 0.05) var perlin_zoom: float = 0.15 
@export var layer_height: int = 20
@export var layer_base_variation: int = 10

@export var layers: Array[LayerData]

@export var player: Player
@onready var layer: TileMapLayer = $PlanetLayers
@onready var ore_layer: TileMapLayer = $OreLayer

# Ore loading
@onready var coal: InventoryItem = preload("res://resources/items/coal_ore.tres")
@onready var iron: InventoryItem = preload("res://resources/items/iron_ore.tres")
@onready var copper: InventoryItem = preload("res://resources/items/copper_ore.tres")

@export var tile_base_life: float = 100.0
var tiles_life: Dictionary[Vector2i, float] = {}
var fast_noise_lite := FastNoiseLite.new()

@onready var mainbase: MainBase = $MainBase
signal ore_block_destructed(ore: InventoryItem)

# Ore + Empty Tile Frequencys
var coal_frequency: float = 0.1
var iron_frequency: float = 0.05
var empty_tile_frequency: float = 0.3

var _loaded_chunks: Array[int] = []

func damage_tile(tile: Vector2i, damage: float) -> void:
	var life: float = tiles_life.get_or_add(tile, tile_base_life)
	if life - damage <= 0:
		var mined_ore: InventoryItem = get_ore_at_coord(tile)
		if mined_ore:
			ore_block_destructed.emit(mined_ore)
			ore_layer.erase_cell(tile)
		destroy_tile(tile)
	else:
		tiles_life[tile] -= damage

func destroy_tile(tile: Vector2i) -> void:
	BetterTerrain.set_cell(layer, tile, -1)
	BetterTerrain.update_terrain_cell(layer, tile)
	tiles_life.erase(tile)

# Settings stuff
func _ready() -> void:
	fast_noise_lite.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	fast_noise_lite.frequency = 0.3
	fast_noise_lite.seed = randi()
	
	load_chunks_by_position(Vector2(0, 0), 0)
	_generate_spawn()

func load_chunks_by_position(position: Vector2, radius: int) -> void:
	var chunk_index: int = floorf(position.x / layer.tile_set.tile_size.x / CHUNK_WIDTH)
	for chunk in range(chunk_index - radius, chunk_index + radius + 1):
		if !_loaded_chunks.has(chunk):
			_load_chunk(chunk)

# This generates a part of the world denoted by CHUNK_WIDTH
func _load_chunk(chunk_index: int) -> void:
	_loaded_chunks.append(chunk_index)
	var initial_x: int = chunk_index * CHUNK_WIDTH
	var final_x: int = initial_x + CHUNK_WIDTH
	
	for layer_index in range(0, layers.size()):
		var layer_base_height: int = (NUMBER_OF_LAYERS - layer_index) * layer_height
		
		# Generates the array of heights.
		var heights: Array[int] = []
		for x in range(initial_x, final_x):
			var height: int = layer_base_height + (fast_noise_lite.get_noise_1d(x * perlin_zoom)) * layer_base_variation
			heights.push_back(height)
		
		# Using the heights generates the tiles
		var tiles_to_place: Array[Vector2i] = []
		for x in range(0, CHUNK_WIDTH):
			for y in range(layer_base_height + layer_base_variation, PLANET_BOTTOM - heights[x], -1):
				tiles_to_place.push_back(Vector2i(x + initial_x, y))
		
		BetterTerrain.set_cells(layer, tiles_to_place, layers[layer_index].terrain_id)
		_generate_ores_in_tiles(tiles_to_place, layers[layer_index])
		await get_tree().physics_frame
	BetterTerrain.update_terrain_area_sliced(layer, Rect2i(initial_x, -20, CHUNK_WIDTH, PLANET_BOTTOM + 20))
	
func _generate_ores_in_tiles(tiles: Array[Vector2i], layer: LayerData) -> void:
	const perlin_zoom := 0.2
	const height_factor := 0.001
	for ore in layer.ores_frequency:
		for tile in tiles:
			if absf(fast_noise_lite.get_noise_2d(tile.x * perlin_zoom, tile.y * perlin_zoom)) + max((-height_factor * tile.y), -0.1) < layer.ores_frequency[ore]:
				_place_ore(tile, ore)

func _get_ore_in_atlas(ore: Enums.Ores) -> Vector2i:
	match ore:
		Enums.Ores.COAL: return Vector2i(0, 0)
		Enums.Ores.IRON: return Vector2i(1, 0)
		Enums.Ores.COPPER: return Vector2i(2, 0)
	return Vector2i(0, 0)

func _place_ore(position: Vector2i, ore: Enums.Ores) -> void:
	ore_layer.set_cell(position, 1, _get_ore_in_atlas(ore))

func _generate_spawn() -> void:
	# TODO: Add some constants to allow easy editing
	# Area cleaning
	var tiles_to_destroy: Array[Vector2i] = []
	for x in range(-8, 8):
		for y in range(-8, -4):
			tiles_to_destroy.push_back(Vector2i(x, y))
			ore_layer.set_cell(Vector2i(x, y), -1)

	BetterTerrain.set_cells(layer, tiles_to_destroy, -1)
	BetterTerrain.update_terrain_area(layer, Rect2i(-8, -8, 17, 9))
	
	player.position = mainbase.position
	

func get_ore_at_coord(local_map_coords: Vector2i) -> InventoryItem:
	var ore_id: Vector2i = ore_layer.get_cell_atlas_coords(local_map_coords)
	match ore_id.x:
		0:
			return coal
		1:
			return iron
		2:
			return copper
	return null
