# Ad Maiorem Dei Gloriam!
class_name InputPanel
extends PanelContainer

var inputs: Dictionary[InventoryItem, Label]
var theme_label: Theme = preload("res://assets/styles/machine_text.tres")
@onready var container: VBoxContainer = $InputPanel
	
func add_input(item: InventoryItem, qtd: int) -> void:
	if inputs.has(item):
		inputs[item].text = str(qtd)
	
	var subcontainer := HBoxContainer.new()
	container.add_child(subcontainer)
	
	var sprite := Sprite2D.new()
	subcontainer.add_child(sprite);
	
	var label := Label.new()
	subcontainer.add_child(label)
	
	sprite.texture = item.texture
	label.text = str(qtd)
	
	label.theme = theme_label
	label.position.x += 20

	inputs[item] = label
