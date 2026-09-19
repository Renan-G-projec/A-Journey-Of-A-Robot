# Ad Maiorem Dei Gloriam!
class_name PlayerInventoryInterfaceItem
extends Control
@onready var label: RichTextLabel = $Label
@onready var sprite: Sprite2D = $Sprite2D

func display_item(item: InventoryItem, qtd: int) -> void:
	sprite.texture = item.texture
	label.text = str(qtd)
	label.position.x = 20
