# Ad Maiorem Dei Gloriam!
class_name Map 
extends Node2D

@onready var layer: TileMapLayer = $PlanetLayer1


@export var tile_base_life: float = 100.0
var tiles_life: Dictionary[Vector2i, float] = {}

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
	var world_width: int = 30
	var layer_1_height: int = 15
	
	
	var map_index: Array = []
	for i in range (world_width): 
		var random_int: int = randi_range(5, layer_1_height) 
		map_index.append(random_int)
	
	for i in range (world_width):
		for j in range(map_index[i-1]):
			var grid_position: Vector2i = Vector2i(i, j+15) 
			var source_id: int = 0
			var atlass: Vector2i = Vector2i(1,1)
			layer.set_cell(grid_position, source_id, atlass)
	
	
	
