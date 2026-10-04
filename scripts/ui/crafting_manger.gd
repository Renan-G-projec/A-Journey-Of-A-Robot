extends Node

var tech_tree: TechtreeUpgrade

func are_prerequisites_met_for_crafting(upgrade: CraftingNode) -> bool:
	print(upgrade)
	for prerequisite: TechtreeUpgrade in upgrade.prerequisites:
		if prerequisite == null:
			continue
		if not tech_tree.has_upgrade(prerequisite):
			return false
		
	return true
