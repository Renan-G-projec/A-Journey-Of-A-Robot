# Ad Maiorem Dei Gloriam!
# AUTOLOAD: TechtreeManager
extends Node

var _root_upgrade: TechtreeUpgrade = preload("res://resources/upgrades/root.tres")

@export var _unlocked_upgrades: Array[TechtreeUpgrade] = [_root_upgrade]
signal upgrade_adquired(upgrade: TechtreeUpgrade)

func add_upgrade(upgrade: TechtreeUpgrade) -> void:
	if _unlocked_upgrades.has(upgrade): return
	_unlocked_upgrades.push_back(upgrade)
	upgrade_adquired.emit(upgrade)

func has_upgrade(upgrade: TechtreeUpgrade) -> bool:
	return _unlocked_upgrades.has(upgrade)
