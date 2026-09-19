# Ad Maiorem Dei Gloriam!
class_name Drill
extends Node2D

## TODO: Refactor this file
## This code mixes particle emission with raycasting and complex behavior
## All the particle-related code shall be moved soon to it's own script

@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: Node2D = $Pivot
@onready var sprite_animation: AnimatedSprite2D = $Pivot/Sprite2D
@onready var selected_block_effect: Sprite2D = $SelectedBlockEffect
@onready var particles: GPUParticles2D = $GPUParticles2D

# Size in tiles
@export var range: int = 4
@export var damage: float = 1
@export var select_lerp_effect: Vector2 = Vector2(1.4, 1.4)
@export var select_lerp_effect_step: float = 0.2

var is_facing_block: bool = false
var facing_block_coords: Vector2i = Vector2.ZERO

signal mined_block(tilemap_position: Vector2i, damage: float)

var facing_block_animation_timer: float = 0
const facing_block_animation_time: float = 0.3

func _physics_process(delta: float) -> void:
    var mouse_pos: Vector2 = get_global_mouse_position()
    var mouse_ang: float = global_position.angle_to_point(mouse_pos)
    sprite.rotation = mouse_ang
    
    var ray_vector: Vector2 = (range * 16 * Vector2.from_angle(mouse_ang))
    raycast.target_position = ray_vector
    
    var changed_facing_block: bool
    var collider: TileMapLayer = raycast.get_collider() as TileMapLayer
    if collider:
        var collision_point: Vector2 = collider.to_local(raycast.get_collision_point() + Vector2.from_angle(mouse_ang) * 0.1)
        
        var collision_tile: Vector2i = collider.local_to_map(collision_point)
        
        changed_facing_block = collision_tile != facing_block_coords
        
        is_facing_block = true;
        facing_block_coords = collision_tile
        
        var global_tile_position: Vector2 = collider.to_global(collider.map_to_local(collision_tile))
        selected_block_effect.global_position = global_tile_position

		# Here it updates in advance. Does not start emitting
		particles.global_position = global_tile_position
		
	else:
		is_facing_block = false;
		
	update_timers(delta)
	update_selected_block_effect(changed_facing_block)

func mine() -> void:
	if (is_facing_block): 
		mined_block.emit(facing_block_coords, damage)
		if (facing_block_animation_timer < 0): 
			selected_block_effect.queue_redraw()
			update_selected_block_effect(true, Vector2(0.7, 0.7))
			facing_block_animation_timer = facing_block_animation_time
		

func update_selected_block_effect(reset_lerp: bool, effect_scale: Vector2 = select_lerp_effect, step: float = select_lerp_effect_step) -> void:
	selected_block_effect.visible = is_facing_block
	if (!is_facing_block): return
	if (reset_lerp):
		selected_block_effect.scale = effect_scale
	selected_block_effect.scale.x = lerp(selected_block_effect.scale.x, 1.0, step)
	selected_block_effect.scale.y = lerp(selected_block_effect.scale.y, 1.0, step)
	

func update_timers(delta: float) -> void:
    facing_block_animation_timer -= delta
    
func start_emitting_particles() -> void:
    particles.emitting = true
    sprite_animation.play()

func _process(_delta: float) -> void:
    if particles.emitting:
        var process_material: ShaderMaterial = particles.process_material as ShaderMaterial
        if process_material:
            process_material.set_shader_parameter("targetPos", sprite.global_position)
            process_material.set_shader_parameter("initial_velocity", Vector2.from_angle(deg_to_rad(randi_range(0, 360))) * 48)
            process_material.set_shader_parameter("initial_offset", Vector2(randi_range(-8, 8), randi_range(-4, 4)))

func stop_emitting_particles() -> void:
    particles.emitting = false
    sprite_animation.stop()
