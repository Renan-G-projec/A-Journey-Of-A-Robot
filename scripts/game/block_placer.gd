# Ad Maiorem Dei Gloriam!
class_name BlockPlacer
extends Node2D

@export var distance: float = 64.0

@onready var ray = $RayCast2D

var is_looking: bool
var looking_tile: Vector2i
var looking_layer: TileMapLayer

func _process(delta: float) -> void:
	var targetpos := (get_global_mouse_position() - global_position).normalized() * distance 
	ray.target_position = targetpos
	
	var collider: TileMapLayer = ray.get_collider() as TileMapLayer
	if collider:
		is_looking = true
		var collision_coords: Vector2 = ray.get_collision_point() + Vector2(-0.1, -0.1)
		var collision_tile := Vector2i(int(floorf(collision_coords.x / collider.tile_set.tile_size.x)), int(floorf(collision_coords.y / collider.tile_set.tile_size.y)))
		
		looking_layer = collider
		looking_tile = collision_tile
	else:
		is_looking = false

func place_block(block_id: int) -> void:
	if !is_looking: return
	BetterTerrain.set_cell(looking_layer, looking_tile, block_id)
	BetterTerrain.update_terrain_cell(looking_layer, looking_tile)
