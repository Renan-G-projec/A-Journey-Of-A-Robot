# Ad Maiorem Dei Gloriam!
class_name FuelUI
extends Control

@onready var fuel_bar: ProgressBar = $Fuel
var jetpack: Jetpack

func set_jetpack(new_jetpack: Jetpack) -> void:
    jetpack = new_jetpack
    fuel_bar.max_value = new_jetpack.max_fuel

func _process(delta: float) -> void:
    if jetpack:
        fuel_bar.value = jetpack.current_fuel
