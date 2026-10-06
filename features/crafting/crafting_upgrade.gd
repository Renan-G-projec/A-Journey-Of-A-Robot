class_name CraftResource 
extends Resource

@export var name: String
@export_multiline var description: String
@export var cost: Inventory
@export var id: int = 0
@export var stock: int = 0
@export var prerequisites: Array[TechtreeUpgrade] = []

func get_requirements_string() -> String:
	var string: String = "Requirements:\n"
	if cost && !cost.data.is_empty(): 
		for item in cost.data:
			string += "    - %d %s.\n" % [cost.get_item(item), item.name]
	else:
		string += "None!" 
	
	return string
