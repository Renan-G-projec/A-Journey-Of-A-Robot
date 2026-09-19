# Ad Maiorem Dei GLoriam!
extends Control

@onready var player_inventory: Inventory = preload("res://resources/player_inventory.tres")

@onready var coal: InventoryItem = preload("res://resources/coal_ore.tres")
@onready var iron: InventoryItem = preload("res://resources/iron_ore.tres")
@onready var copper: InventoryItem = preload("res://resources/copper_ore.tres")

@onready var coal_label: PlayerInventoryInterfaceItem = $VBoxContainer/coal
@onready var iron_label: PlayerInventoryInterfaceItem = $VBoxContainer/iron
@onready var copper_label: PlayerInventoryInterfaceItem = $VBoxContainer/copper

@onready var item_labels: Dictionary[InventoryItem, PlayerInventoryInterfaceItem] = {coal: coal_label, iron: iron_label, copper: copper_label}

func _ready() -> void:
	coal_label.display_item(coal, player_inventory.data.get(coal, 0))
	iron_label.display_item(iron, player_inventory.data.get(iron, 0))
	copper_label.display_item(copper, player_inventory.data.get(copper, 0))
	
	player_inventory.inventory_item_changed.connect(_on_player_inventory_item_changed)
	
func _on_player_inventory_item_changed(item: InventoryItem, new_qtd: int) -> void:
	item_labels[item].display_item(item, new_qtd)
