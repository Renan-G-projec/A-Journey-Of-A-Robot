# Ad Maiorem Dei Gloriam!
# AUTOLOAD: TechtreeManager
extends Node

var _root_upgrade: TechtreeUpgrade = preload("res://features/techtree/data/root.tres")

@export var _unlocked_upgrades: Array[TechtreeUpgrade] = [_root_upgrade]
signal upgrade_adquired(upgrade: TechtreeUpgrade)

func add_upgrade(upgrade: TechtreeUpgrade) -> void:
	if _unlocked_upgrades.has(upgrade): return
	if not are_prerequisites_met_for_tech(upgrade):
		print("Cannot unlock %s: prerequisites are not met" % upgrade.name)
	_unlocked_upgrades.push_back(upgrade)
	upgrade_adquired.emit(upgrade)

func has_upgrade(upgrade: TechtreeUpgrade) -> bool:
	return _unlocked_upgrades.has(upgrade)

func are_prerequisites_met_for_tech(upgrade: TechtreeUpgrade) -> bool:
	for prerequisite: TechtreeUpgrade in upgrade.prerequisites:
		if prerequisite == null:
			continue
		if not has_upgrade(prerequisite):
			return false
		
	return true

func has_upgrades(upgrades: Array[TechtreeUpgrade]) -> bool:
	for upgrade in upgrades:
		if !has_upgrade(upgrade):
			return false
	return true
		
