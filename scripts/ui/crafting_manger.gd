extends Node


signal increase_building_stock()

#signal upgrade_adquired(upgrade: CraftResource, new_amount: int)

#var craft_data: Dictionary[CraftingButton, int] = {}

#func add_upgrade(upgrade: CraftResource) -> void:
	#var new_amount: int = get_upgrade_amount(upgrade) + 1
	#_upgrade_amount[upgrade] = new_amount
	#upgrade_adquired.emit(upgrade, new_amount)
#
#
#func has_upgrade(upgrade: CraftResource, min_level: int = 1) -> bool:
	#return get_upgrade_amount(upgrade) >= min_level
#
#
#func get_upgrade_amount(upgrade: CraftResource) -> int:
	#return _upgrade_amount[upgrade]
	
func are_prerequisites_met_for_crafting(craft_resource: CraftResource) -> bool:
	for prerequisite: TechtreeUpgrade in craft_resource.prerequisites:
		if not TechtreeManager.has_upgrade(prerequisite):
			return false
	return true


func add_craft_resource(item: CraftResource) -> void:
	
	item.stock = item.stock + 1
	increase_building_stock.emit(item)
	
	
#func get_all_craft_resources() -> Array[CraftResource]:
	
	

#func get_item(item: CraftResource) -> int:
	#return data.get(item, 0)

#func remove_item(item: CraftingButton, qtd: int) -> void:
	#if !data.has(item): return
	#elif data[item] - qtd <= 0: data[item] = 0
	#else: data.set(item, data[item] - qtd)
	

#func remove_items(items: Inventory) -> void:
	#for item in items.data:
		#remove_item(item, items.get_item(item))

#func add_items(items: Inventory) -> void:
	#for item in items.data:
		#add_item(item, items.get_item(item))
		
#func has_items(items: Inventory) -> bool:
	#for item in items.data:
		#var item_to_check_qtd: int = items.data.get(item, 0)
		#var item_on_inventory_qtd: int = data.get(item, 0)
		#if item_on_inventory_qtd < item_to_check_qtd:
			#return false
	#return true
