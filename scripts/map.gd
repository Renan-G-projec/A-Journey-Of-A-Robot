# Ad Maiorem Dei Gloriam!
class_name Map 
extends Node2D

@onready var layer: TileMapLayer = $PlanetLayer1
@onready var ore: TileMapLayer= $OreLayer1

@export var tile_base_life: float = 100.0
var tiles_life: Dictionary[Vector2i, float] = {}
var fast_noise_lite := FastNoiseLite.new()



func damage_tile(tile: Vector2i, damage: float) -> void:
	var life: float = tiles_life.get_or_add(tile, tile_base_life)
	if life - damage <= 0:
		destroy_tile(tile)
	else:
		tiles_life[tile] -= damage
	
func destroy_tile(tile: Vector2i) -> void:
	layer.set_cells_terrain_connect([tile], 0, -1)
	tiles_life.erase(tile)
	
func _ready() -> void:
	fast_noise_lite.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH 
	fast_noise_lite.frequency = 0.3
	fast_noise_lite.seed = randi()
	layer.clear()
	generateMap()

	
	#var world_width: int = 30 
	#var layer_1_height: int = 15 
	#var map_index_height: Array = [] 
	#var map_index_skim: Array = [] 
	#var positions_to_change: Array[Vector2i] = [] 
	#
	#for i in range (world_width): 
		#var random_height_int: int = randi_range(5, layer_1_height) 
		#map_index_height.append(random_height_int) 
		#var random_width_skim: int = randi_range(0, 3) 
		#map_index_skim.append(random_width_skim) 
		#
	#for i in range (world_width): 
		#var y_skim: int = map_index_skim[i] 
		#var column_height: int = map_index_height[i] 
		#
		#for j in range(y_skim, column_height): 
			#var grid_position: Vector2i = Vector2i(i, j+15) 
			#positions_to_change.push_back(grid_position) 
			#
	#layer.set_cells_terrain_connect(positions_to_change, 0, 0)
	
func generateMap() -> void: 
	print("Generating map cells...")
	var tiles_placed: int = generateTile()
	var updated_tiles_placed: int = removeTiles(tiles_placed)
	generateOre(updated_tiles_placed)
	
func generateTile() -> int:
	
	var world_width: int = 30
	var world_height: int = 30
	
	var spike_height: int = 10
	
	var top_wall: int = 5 
	var tiles_to_place: Array[Vector2i] = []
	var min_body_thickness: int = 20
	
	for x in range (world_width):
	
		var current_top := top_wall
		
		var bottom_noise := fast_noise_lite.get_noise_1d((x*25)+500)
		var current_bottom := top_wall + min_body_thickness + int(bottom_noise * spike_height)
		
		for y in range(current_top, current_bottom):
			tiles_to_place.push_back(Vector2i(x, y))
		
	layer.set_cells_terrain_connect(tiles_to_place, 0, 0)
	
	var tiles_placed: int = tiles_to_place.size()
	
	print("Total tiles placed: ", tiles_placed)
	
	return int(tiles_placed)

func generateOre (updated_tiles_placed:int) -> void:
	
	print("generateOre")
	print("tiles_placed: ", updated_tiles_placed)
	var rng := RandomNumberGenerator.new()

	var coal_frequency: float = 0.1
	var iron_frequency: float = 0.05
	
	var coal_tiles: int = roundi(updated_tiles_placed * coal_frequency )
	var iron_tiles: int = roundi(updated_tiles_placed * iron_frequency )
	print("Coal Tiles: ", coal_tiles )
	print("Iron Tiles: ", iron_tiles )
	
	
	for i in range(coal_tiles):
		var is_empty: bool = true 
		while is_empty:
			var random_cord := Vector2i(rng.randi_range(1,29), rng.randi_range(7,35))
			print("Random Coordiante", random_cord)
			if layer.get_cell_source_id(random_cord) != -1: 
				print("Tile Exists ")
				ore.set_cell(random_cord, 1, Vector2i(0,0))
				is_empty = false
		
			else: 
				print("Tile Does Not Exist")
				is_empty = true 
	
	for i in range(iron_tiles):
		var is_empty: bool = true 
		while is_empty:
			var random_cord := Vector2i(rng.randi_range(1,29), rng.randi_range(7,35))
			print("Random Coordiante", random_cord)
			if layer.get_cell_source_id(random_cord) != -1: 
				print("Tile Exists ")
				ore.set_cell(random_cord, 1, Vector2i(1,0))
				is_empty = false
		
			else: 
				print("Tile Does Not Exist")
				is_empty = true 

func removeTiles (tiles_placed:int)	-> int:
	var removable_value: float = 0.2
	var tiles_removed: int = 0 
	for x in range (1,29):
		for y in range(8,35):
			var coords := Vector2i(x,y)
	
			if layer.get_cell_source_id(coords) != -1: 
				var noise_val := fast_noise_lite.get_noise_2d(x,y)
				
				if noise_val > removable_value:
					layer.erase_cell(coords)
					tiles_removed = tiles_removed + 1
				else: 
					continue
			else: 
				continue
	var updated_tiles_placed := tiles_placed - tiles_removed
	return updated_tiles_placed
			
	
	
			
		
		
		
	
	


	
	
	
