extends Node

func sync_stock(item: BuildingResource )-> void:
	item.stock = item.craft_connection.stock

func remove_stock(item: BuildingResource, qty: int )-> void:
	item.craft_connection.stock	= item.craft_connection.stock - qty





#func are_prerequisites_met_for_building(building_resource: BuildingResource) -> bool:
	#for prerequisite: CraftResource in building_resource.prerequisites:
		#if not CraftingManger.has_upgrade(prerequisite):
			#return false
	#return true
	#
#func list_prerequisties(upgrade: BuildingResource) -> CraftResource:
	#for prerequisite:CraftResource in upgrade.prerequisites:
		#craft = prerequisite
	#return craft
