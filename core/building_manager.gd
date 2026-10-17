extends Node

func sync_stock(item: BuildingResource )-> void:
	item.stock = item.craft_connection.stock

func remove_stock(item: BuildingResource, qty: int )-> void:
	item.craft_connection.stock	= item.craft_connection.stock - qty
