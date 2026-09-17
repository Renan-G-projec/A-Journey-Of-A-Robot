extends Control

@onready var fuel_bar: ProgressBar = $Fuel

func set_fuel(value: float) -> void:
    fuel_bar.value = value
