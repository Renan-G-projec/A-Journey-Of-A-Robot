# Ad Maiorem Dei GLoriam!
@tool
extends Control

@export var player_inventory: Inventory = preload("res://resources/inventories/player_inventory.tres")
@onready var container: VBoxContainer = $VBoxContainer

@onready var container_item: PackedScene = preload("res://scenes/ui/player_inventory_interface_item.tscn")

var items_shown: Array[InventoryItem]

func _ready() -> void:
	player_inventory.inventory_item_changed.connect(_on_player_inventory_item_changed)
	fetch_inventory()
	
func _on_player_inventory_item_changed(item: InventoryItem, new_qtd: int) -> void:
	var item_index: int = items_shown.find(item)
	var children: Array[Node] = container.get_children()
	if item_index >= 0:
		var item_interface: PlayerInventoryInterfaceItem = children[item_index] as PlayerInventoryInterfaceItem
		if item_interface: item_interface.display_item(item, new_qtd)
	else:
		var item_to_display := container_item.instantiate()
		container.add_child(item_to_display)
		item_to_display.display_item(item, player_inventory.get_item(item))
		items_shown.push_back(item)

func fetch_inventory() -> void:
	items_shown = []
	for i in container.get_children(): i.queue_free()
	for item in player_inventory.data:
		var item_to_display := container_item.instantiate()
		container.add_child(item_to_display)
		item_to_display.display_item(item, player_inventory.get_item(item))
		items_shown.push_back(item)
