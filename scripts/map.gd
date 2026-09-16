# Ad Maiorem Dei Gloriam!
class_name Map 
extends Node2D

@onready var layer: TileMapLayer = $PlanetLayer1

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
	for x in range (30):
		for y in range (30):
			layer.set_cell(Vector2i(x, y), 0, Vector2i(1, 1))
	print("Finished setting cells!")
	var used_cells := layer.get_used_cells()
	print("Cells in memory: ", used_cells.size())

			
	
	
	
