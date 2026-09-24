extends Button

var neighbors: Array = [] : set = set_neighbors
var lines : Array = []
var neighbor_lines : Array = []
var delay := 10

func add_line(neighbor: Button) -> void:
	var line: Line2D = Line2D.new()
	line.width = 4
	line.z_index = -1
	line.add_point(global_position + size / 2)
	line.add_point(neighbor.global_position + neighbor.size/2)
	
	lines.push_back(line)
	neighbor.neighbor_lines.push_back(line)
	get_parent().add_child(line)

func update_lines() -> void:
	for line: Line2D in lines:
		line.set_point_position(0, global_position + size/2)
	for line: Line2D in neighbor_lines:
		line.set_point_position(1, global_position + size / 2)

func set_neighbors (new_neighbors: Array) -> void:	
	for neighbor: Button in new_neighbors:
		if not neighbors.has(neighbor):
			add_line(neighbor)
	neighbors = new_neighbors
func _on_Button_toggled(button_pressed: Button) -> void:
	if button_pressed:
		for neigbor: Button in neighbors:
			neigbor.disabled = false
			

func _process(delta: float) -> void:	
	if Input.is_action_just_pressed("ui_left") and is_hovered():
		delay = delay - 1
		if delay < 0:
			position = get_global_mouse_position() - size/2
			update_lines()
	if Input.is_action_just_released("ui_left"):
		delay = 10
		
		
	
	
	
	
	
