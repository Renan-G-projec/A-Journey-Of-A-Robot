# Ad Maiorem Dei Gloriam!
class_name Jetpack
extends Node

# This file exists only to encapsulate the jetpack logic and remove it from the player script
# Jetpack settings. FUEL MEASURED IN SECONDS
@export var max_fuel: float = 5.0
@export var current_fuel: float = 5.0
@export var impulse: float = 980 * 1.4
@export var refuel_rate: float = 0.05

var is_active: bool = false

func get_jetpack_velocity(delta: float) -> float:
    if !is_active || current_fuel <= 0: return 0
    return -impulse * delta;

func _physics_process(delta: float) -> void:
    if is_active: 
        current_fuel -= delta
    else:
        current_fuel += refuel_rate * delta
        current_fuel = min(current_fuel, max_fuel)
    
