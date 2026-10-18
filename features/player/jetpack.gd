# Ad Maiorem Dei Gloriam!
class_name Jetpack
extends Node

var copper_jetpack: TechtreeUpgrade = preload("res://features/techtree/data/copper_techs/copper_jetpack.tres")
var iron_jetpack: TechtreeUpgrade = preload("res://features/techtree/data/iron_techs/iron_jetpack.tres")
var topaz_jetpack: TechtreeUpgrade = preload("res://features/techtree/data/topaz_techs/topaz_jetpack.tres")
var emerald_jetpack: TechtreeUpgrade = preload("res://features/techtree/data/emerald_techs/emerald_jetpack.tres")
var ruby_jetpack: TechtreeUpgrade = preload("res://features/techtree/data/ruby_techs/ruby_jetpack.tres")

# This file exists only to encapsulate the jetpack logic and remove it from the player script
# Jetpack settings. FUEL MEASURED IN SECONDS
@export var max_fuel: float
@export var current_fuel: float
@export var impulse: float
@export var refuel_rate: float
@export var boost_refuel_rate: float


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

func _process(delta: float) -> void:
	if TechtreeManager.has_upgrade(ruby_jetpack):
		max_fuel = 14.0
		impulse = 980.0 * 2.4
		refuel_rate = 0.6
		boost_refuel_rate = 6.5
	elif TechtreeManager.has_upgrade(emerald_jetpack):
		max_fuel = 12.0
		impulse = 980.0 * 2.2
		refuel_rate = 0.5
		boost_refuel_rate = 6.0
	elif TechtreeManager.has(topaz_jetpack):
		max_fuel = 10.0
		impulse = 980.0 * 2.0
		refuel_rate = 0.4
		boost_refuel_rate = 5.5
	elif TechtreeManager.has(iron_jetpack):
		max_fuel = 8.0
		impulse = 980.0 * 1.8 
		refuel_rate = 0.3
		boost_refuel_rate = 5.0
	elif TechtreeManager.has_upgrade(copper_jetpack):
		max_fuel = 6.0
		impulse = 980.0 * 1.6
		refuel_rate = 0.2
		boost_refuel_rate = 4.5
	else: 
		max_fuel = 4.0
		impulse = 980.0 * 1.4
		refuel_rate = 0.1
		boost_refuel_rate = 4.0
		
