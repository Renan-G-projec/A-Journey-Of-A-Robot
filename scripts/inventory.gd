class_name Inventory
extends Node

@export var data: Dictionary[InventoryItem, int] = {}

func add_item(item: InventoryItem, qtd: int) -> void:
    data[item] = data.get(item, 0)
    EventBus.inventory_changed.emit(item, data[item])

func remove_item(item: InventoryItem, qtd: int) -> void:
    if !data.has(item): return
    elif data[item] - qtd <= 0: data[item] = 0
    else: data.set(item, data[item] - qtd)
    EventBus.inventory_changed.emit(item, data[item])
