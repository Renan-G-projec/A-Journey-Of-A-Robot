class_name BuildingResource
extends Resource

@export var name: String
@export_multiline var description: String
@export var stock: int = 0
@export var id: int = 0
@export var craft_connection: CraftResource

func get_current_stock() -> int:
	if craft_connection:
		return craft_connection.stock
	return stock

func get_requirements_string() -> String:
	var string: String = "Requirements:\n"

	if craft_connection == null:
		string += "    None!\n"
		return string

	string += "    - %s: %d\n" % [name, get_current_stock()]

	return string
