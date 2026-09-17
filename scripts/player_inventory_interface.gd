extends Control

@onready var player_inventory: Inventory = preload("res://resources/player_inventory.tres")
@onready var container_items: PackedScene = preload("res://scenes/player_inventory_interface_item.tscn")
@onready var container: VBoxContainer = $VBoxContainer

func _ready() -> void:
    player_inventory.inventory_item_changed.connect(_on_player_inventory_item_changed)
    for i in player_inventory.data:
        var item_instance: Control = container_items.instantiate()
        container.add_child(item_instance)
        var sprite: Sprite2D = item_instance.get_node("Sprite2D")
        sprite.texture = i.texture
        var label: RichTextLabel = item_instance.get_node("Label")
        label.text = str(player_inventory.data[i])
        label.position.x += 20 # 16px of sprite2d + 4 padding
        
    
func _on_player_inventory_item_changed(item: InventoryItem, new_qtd: int) -> void:
    pass
