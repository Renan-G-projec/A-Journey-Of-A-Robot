# Ad Maiorem Dei Gloriam!
class_name LayerData
extends Resource

# This file is meant to be the layer configuration data. It is used in res://scripts/game/map.gd and can be set on the inspector
@export var terrain_id: int
@export var ores_frequency: Dictionary[Enums.Ores, float]
