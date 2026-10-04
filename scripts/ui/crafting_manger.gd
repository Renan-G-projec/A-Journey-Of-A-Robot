extends Node

signal upgrade_adquired(upgrade: CraftingUpgrade, new_amount: int)

@export var _starting_upgrades: Array[CraftingUpgrade]

var _upgrade_amount: Dictionary[CraftingUpgrade, int] = {}


func _ready() -> void:
	for upgrade in _starting_upgrades:
		add_upgrade(upgrade)


func add_upgrade(upgrade: CraftingUpgrade) -> void:
	var new_amount: int = get_upgrade_amount(upgrade) + 1
	_upgrade_amount[upgrade] = new_amount
	upgrade_adquired.emit(upgrade, new_amount)


func has_upgrade(upgrade: CraftingUpgrade, min_level: int = 1) -> bool:
	return get_upgrade_amount(upgrade) >= min_level


func get_upgrade_amount(upgrade: CraftingUpgrade) -> int:
	return _upgrade_amount.get(upgrade, 0)


func are_prerequisites_met_for_crafting(upgrade: CraftingUpgrade) -> bool:
	for prerequisite: TechtreeUpgrade in upgrade.prerequisites:
		if not TechtreeManager.has_upgrade(prerequisite):
			return false
	return true
