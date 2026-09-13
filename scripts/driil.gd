extends Node2D

@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: Node2D = $Pivot
@onready var selected_block_effect: Sprite2D = $SelectedBlockEffect

# Size in tiles
@export var range: int = 4

signal mined_block(tilemap_position: Vector2i)

func _physics_process(delta: float) -> void:
    var mouse_pos: Vector2 = get_global_mouse_position()
    var mouse_ang: float = global_position.angle_to_point(mouse_pos)
    sprite.rotation = mouse_ang
    
    var ray_vector: Vector2 = (range * 16 * Vector2.from_angle(mouse_ang))
    raycast.target_position = ray_vector
    
    var collider: TileMapLayer = raycast.get_collider() as TileMapLayer
    if collider:
        var collision_point: Vector2 = collider.to_local(raycast.get_collision_point() + Vector2.from_angle(mouse_ang) * 0.1)
        
        var collision_tile: Vector2i = collider.local_to_map(collision_point)
        
        selected_block_effect.visible = true;
        selected_block_effect.global_position = collider.to_global(collider.map_to_local(collision_tile))
        
        mined_block.emit(collision_tile)
    else:
        selected_block_effect.visible = false;
