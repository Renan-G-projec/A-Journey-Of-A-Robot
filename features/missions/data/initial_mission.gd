# Ad Maiorem Dei Gloriam!
extends Mission

const coal_amount: int = 10
const iron_amount: int = 5
const player_inventory: Inventory = preload("res://features/player/player_inventory.tres")

const COAL_ORE = preload("uid://bko8wv0d2j44d")
const IRON_ORE = preload("uid://lk30ldug605k")

func _init() -> void:
	player_inventory.inventory_item_changed.connect(func (_item: InventoryItem, _qtd: int): _sync_progress())
	_sync_progress()
	
func get_string() -> String:
	return "Collect [color=lime]%d/%d[/color] coals\nCollect [color=lime]%d/%d[/color] irons" % [player_inventory.get_item(COAL_ORE), coal_amount, player_inventory.get_item(IRON_ORE), iron_amount]

func _sync_progress() -> void:
	changed.emit()
	
	if player_inventory.get_item(COAL_ORE) >= coal_amount && player_inventory.get_item(IRON_ORE) >= coal_amount:
		completed.emit()
