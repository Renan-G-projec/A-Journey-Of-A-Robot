extends Control

const TECH_TREE_PATH := "res://data/tech_tree.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_tech_tree() -> void:
	var file := FileAccess.open(TECH_TREE_PATH, FileAccess.READ)

	if file == null:
		push_error("Could not open tech tree file: " + TECH_TREE_PATH)
		return

	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())

	if parse_result != OK:
		push_error("Invalid tech tree JSON: " + json.get_error_message())
		return

	var data = json.data

	if not data is Dictionary:
		push_error("Tech tree JSON needs a 'technologies' array.")
		return

	for tech in data:
		var techs: Array = data[tech]
		
		for level in techs:
			var id: String = tech["id"]
			var name: String = tech["name"]
		
		var tech_id: String = tech["id"]
		technologies[tech_id] = tech
