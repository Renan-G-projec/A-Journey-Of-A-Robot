extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sub_viewport_container_resized() -> void:
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size


func _on_button_pressed() -> void:
	$SubViewportContainer/SubViewport/Techtree.reset_nodes() # Replace with function body.


func _on_h_slider_value_changed(value: float) -> void:
	$ViewportContainer/Viewport/Camera2D.zoom.x = value
	$ViewportContainer/Viewport/Camera2D.zoom.y = value
