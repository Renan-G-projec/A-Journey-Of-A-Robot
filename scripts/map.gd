# Ad Maiorem Dei Gloriam!
class_name Map 
extends Node2D

@onready var layer: TileMapLayer = $PlanetLayer1

@export var tile_base_life: float = 100.0
var tiles_life: Dictionary[Vector2i, float] = {}

func damage_tile(tile: Vector2i, damage: float) -> void:
    var life: float = tiles_life.get_or_add(tile, tile_base_life)
    print("LIFEc", life)
    if life - damage <= 0:
        destroy_tile(tile)
    else:
        tiles_life[tile] -= damage
    
func destroy_tile(tile: Vector2i) -> void:
    layer.set_cells_terrain_connect([tile], 0, -1)
