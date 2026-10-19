# Ad Maiorem Dei Gloriam!
class_name BlockPlacer
extends Node2D

@export var distance: float = 64.0

@onready var ray = $RayCast2D

var is_looking: bool
var looking_tile: Vector2i
var looking_layer: TileMapLayer
var collision_coords: Vector2

func _process(delta: float) -> void:
	var targetpos := (get_global_mouse_position() - global_position).normalized() * distance 
	ray.target_position = targetpos
	
	var collider: TileMapLayer = ray.get_collider() as TileMapLayer
	if collider:
		is_looking = true
		
		# The player shouldbt be able to place blocks on itself
		var ray_length: float = (ray.get_collision_point() - ray.global_position).length()
		if ray_length < 16.0:
			is_looking = false
			return

		collision_coords = ray.get_collision_point() + ray.get_collision_normal() * 0.5
		var collision_tile := collider.local_to_map(collision_coords)

		looking_layer = collider
		looking_tile = collision_tile
	else:
		is_looking = false

# returns true if the block was placed and false if not
func place_block(block_id: int) -> bool:
	if !is_looking: return false

	BetterTerrain.set_cell(looking_layer, looking_tile, block_id)
	BetterTerrain.update_terrain_cell(looking_layer, looking_tile)
	
	return true
