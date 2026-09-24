# Ad Maiorem Dei Gloriam!
@tool
class_name InputPanel
extends PanelContainer

@export var input: Inventory:
	set(val):
		input = val
		inputs.clear()
		if is_inside_tree() and container:
			clear_inputs()
			if input and input.data:
				update_editor_sprite()

var inputs: Dictionary[InventoryItem, Label]
var theme_label: Theme = preload("res://assets/styles/machine_text.tres")
@onready var container: VBoxContainer = $InputPanel
	
	
func _ready() -> void:
	position.x -= size.x * scale.x / 2
	
func add_input(item: InventoryItem, qtd: int) -> void:
	if inputs.has(item):
		inputs[item].text = str(qtd)
		return
	
	var subcontainer := HBoxContainer.new()
	container.add_child(subcontainer)
	
	var sprite := TextureRect.new()
	subcontainer.add_child(sprite);
	
	var label := Label.new()
	subcontainer.add_child(label)
	
	sprite.texture = item.texture
	label.text = str(qtd)
	
	label.theme = theme_label

	inputs[item] = label
	
func update_editor_sprite() -> void:
	if !input: return
	for item in input.data:
		add_input(item, input.get_item(item))

func clear_inputs() -> void:
	inputs.clear()
	for i in container.get_children():
		i.queue_free()
