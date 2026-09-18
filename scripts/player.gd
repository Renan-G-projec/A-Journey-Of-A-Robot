# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -400.0
@export var inventory: Inventory

@onready var drill: Drill = $Drill
@onready var sprite: AnimatedSprite2D = $Sprite

var facing_direction: int = 1

signal fuel_changed(new_fuel: float)
signal mined_block(tilemap_coords: Vector2i, damage: float)

# Jetpack settings. FUEL MEASURED IN SECONDS
const jetpack_max_fuel: float = 5.0
var jetpack_current_fuel: float = 5.0
var jetpack_is_active: bool = false

var jetpack_impulse: float = 980 * 2
var jetpack_max_velocity: float = 980 * 8

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity() * delta

    jetpack_is_active = Input.is_action_pressed("UseJetpack") && jetpack_current_fuel > 0
    if jetpack_is_active:
        jetpack_current_fuel -= delta
        velocity.y -= jetpack_impulse * delta;
        velocity.y = max(velocity.y, -jetpack_max_velocity)
        fuel_changed.emit(jetpack_current_fuel)
        
    if Input.is_action_pressed("MineFacingBlock"):
        if (drill.is_facing_block): drill.start_emitting_particles()
        drill.mine()
    else:
        drill.stop_emitting_particles()
    if !(drill.is_facing_block): drill.stop_emitting_particles()
    
    var direction := Input.get_axis("GoLeft", "GoRight")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    update_state()


func _on_driil_mined_block(tilemap_position: Vector2i, damage: float) -> void:
    mined_block.emit(tilemap_position, damage)
    
func update_state() -> void:
    var going_direction: int = Input.get_axis("GoLeft", "GoRight")
    if going_direction < 0:
        sprite.play("runningLeft")
        facing_direction = going_direction
    elif going_direction > 0:
        sprite.play("runningRight")
        facing_direction = going_direction
    else:
        if (facing_direction < 0): sprite.play("idleLeft")
        else: sprite.play("idleRight")
        
