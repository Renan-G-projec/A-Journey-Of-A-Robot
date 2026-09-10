# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -400.0

# Jetpack settings
const jetpack_max_fuel: float = 100.0
var jetpack_current_fuel: float = 100.0
var jetpack_consume_rate: float = 10.0
var jetpack_impulse: float = 40.0
var jetpack_max_velocity: float = 230.0 
var jetpack_is_active: bool = false


func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity() * delta

    jetpack_is_active = Input.is_action_pressed("UseJetpack") && jetpack_current_fuel > 0
    if jetpack_is_active:
        jetpack_current_fuel -= jetpack_consume_rate * delta
        print(velocity.y)
        velocity.y -= jetpack_impulse;
        velocity.y = max(velocity.y, -jetpack_max_velocity)
        

    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
