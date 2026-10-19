# Ad Maiorem Dei Gloriam!
class_name Jetpack
extends Node



# This file exists only to encapsulate the jetpack logic and remove it from the player script
# Jetpack settings. FUEL MEASURED IN SECONDS
@export var max_fuel: float = 4.0
@export var current_fuel: float = 4.0
@export var impulse: float = 980 * 1.4
@export var refuel_rate: float = 0.1
@export var boost_refuel_rate: float = 4.0

var copper_jetpack_tech: TechtreeUpgrade = preload("res://features/techtree/data/copper_techs/copper_jetpack.tres")
var iron_jetpack_tech: TechtreeUpgrade = preload("res://features/techtree/data/iron_techs/iron_jetpack.tres")
var topaz_jetpack_tech: TechtreeUpgrade = preload("res://features/techtree/data/topaz_techs/topaz_jetpack.tres")
var emerald_jetpack_tech: TechtreeUpgrade = preload("res://features/techtree/data/emerald_techs/emerald_jetpack.tres")
var ruby_jetpack_tech: TechtreeUpgrade = preload("res://features/techtree/data/ruby_techs/ruby_jetpack.tres")

var boost: bool = false

var is_active: bool = false

func get_jetpack_velocity(delta: float) -> float:
	if !is_active || current_fuel <= 0: return 0
	return -impulse * delta;

func _physics_process(delta: float) -> void:
	
	if is_active: 
		current_fuel -= delta
		current_fuel = max(current_fuel, 0)
	else:
		if boost:current_fuel += refuel_rate * delta * boost_refuel_rate
		else: current_fuel += refuel_rate * delta
		current_fuel = min(current_fuel, max_fuel)

func update_upgrade_stats() -> void:
	if TechtreeManager.has_upgrade(ruby_jetpack_tech):
		max_fuel = 12.0
		impulse = 980 * 2.2
		refuel_rate = 0.5
	elif TechtreeManager.has_upgrade(emerald_jetpack_tech):
		max_fuel = 10.0
		impulse = 980 * 2.0
		refuel_rate = 0.4
	elif TechtreeManager.has_upgrade(topaz_jetpack_tech):
		max_fuel = 8.0
		impulse = 980 * 1.8
		refuel_rate = 0.3
	elif TechtreeManager.has_upgrade(iron_jetpack_tech):
		max_fuel = 6.0
		impulse = 980 * 1.6
		refuel_rate = 0.2
	elif TechtreeManager.has_upgrade(copper_jetpack_tech):
		max_fuel = 5.0
		impulse = 980 * 1.5
		refuel_rate = 0.15
	else:
		max_fuel = 4.0
		impulse = 980 * 1.4
		refuel_rate = 0.1

func _process(delta: float) -> void:
	update_upgrade_stats()
