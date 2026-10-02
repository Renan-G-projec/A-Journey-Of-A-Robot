class_name Inventory
extends Resource

@export var data: Dictionary[InventoryItem, int] = {}
signal inventory_item_changed(item: InventoryItem, new_qtd: int)

func add_item(item: InventoryItem, qtd: int) -> void:
	data[item] = data.get(item, 0) + qtd
	inventory_item_changed.emit(item, data[item])

func get_item(item: InventoryItem) -> int:
	return data.get(item, 0)

func remove_item(item: InventoryItem, qtd: int) -> void:
	if !data.has(item): return
	elif data[item] - qtd <= 0: data[item] = 0
	else: data.set(item, data[item] - qtd)
	inventory_item_changed.emit(item, data[item])

func remove_items(items: Inventory) -> void:
	for item in items.data:
		remove_item(item, items.get_item(item))

func add_items(items: Inventory) -> void:
	for item in items.data:
		add_item(item, items.get_item(item))
		
func has_items(items: Inventory) -> bool:
	for item in items.data:
		var item_to_check_qtd: int = items.data.get(item, 0)
		var item_on_inventory_qtd: int = data.get(item, 0)
		if item_on_inventory_qtd < item_to_check_qtd:
			return false
	return true
