extends Node

var craft: CraftingUpgrade 


func are_prerequisites_met_for_building(upgrade: BuildingUpgrade) -> bool:
	for prerequisite: CraftingUpgrade in upgrade.prerequisites:
		if not CraftingManger.has_upgrade(prerequisite):
			return false
	return true
	
func list_prerequisties(upgrade: BuildingUpgrade) -> CraftingUpgrade:
	for prerequisite:CraftingUpgrade in upgrade.prerequisites:
		craft = prerequisite
	return craft
