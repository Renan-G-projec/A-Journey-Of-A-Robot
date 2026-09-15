class_name Inventory
extends Resource

@export var data: Dictionary[InventoryItem, int] = {}
signal inventory_item_changed(item: InventoryItem, new_qtd: int)

func add_item(item: InventoryItem, qtd: int) -> void:
    data[item] = data.get(item, 0)
    inventory_item_changed.emit(item, data[item])

func remove_item(item: InventoryItem, qtd: int) -> void:
    if !data.has(item): return
    elif data[item] - qtd <= 0: data[item] = 0
    else: data.set(item, data[item] - qtd)
    inventory_item_changed.emit(item, data[item])
