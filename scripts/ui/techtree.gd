extends Control

var reset: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_stage1.neighbors= [$drill_stage1, $furnance_stage1]
	for child in get_children():
		if child is Button:
			reset.push_back(child.position)
