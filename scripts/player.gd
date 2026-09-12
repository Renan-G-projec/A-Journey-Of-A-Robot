# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -400.0

signal fuel_changed(new_fuel: float)

# Jetpack settings
const jetpack_max_fuel: float = 100.0
var jetpack_current_fuel: float = 100.0
var jetpack_consume_rate: float = 100.0
var jetpack_is_active: bool = false

var jetpack_impulse: float = 980 * 2
var jetpack_max_velocity: float = 980 * 8

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity() * delta

    jetpack_is_active = Input.is_action_pressed("UseJetpack") && jetpack_current_fuel > 0
    if jetpack_is_active:
        jetpack_current_fuel -= jetpack_consume_rate * delta
        velocity.y -= jetpack_impulse * delta;
        velocity.y = max(velocity.y, -jetpack_max_velocity)
        fuel_changed.emit(jetpack_current_fuel)
        

    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
