class_name BuildingUpgrade
extends Resource

@export var name: String
@export_multiline var description: String
@export var amount: Dictionary[CraftingUpgrade, int]
@export var id: int = 0
@export var prerequisites: Array[CraftingUpgrade] = []

func get_requirements_string() -> String:
	var string: String = "Requirements:\n"
	
	if amount.is_empty():
		string += "None!"
		return string
	
	for item:CraftingUpgrade in amount:
		string += "    - %d %s.\n" % [amount[item], item.name]
	
	return string
