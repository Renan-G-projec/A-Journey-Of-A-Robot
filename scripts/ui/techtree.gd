extends Control

var reset: Array = []



func reset_nodes() -> void:
	var index: int = 0
	for child in get_children():
		if child is Button:
			child.position = reset[index]
			child.update_lines()
			index = index + 1
			child.pressed = false	
			if child != $A:
				child.disabled = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$A.neighbors= [$B, $C]
	$B.neighbors= [$D, $E]
	$C.neighbors= [$F, $G]
	for child in get_children():
		if child is Button:
			reset.push_back(child.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
