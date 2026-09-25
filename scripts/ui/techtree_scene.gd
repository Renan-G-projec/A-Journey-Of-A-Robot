extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("OpenTechTree"):
		get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")


func _on_sub_viewport_container_resized() -> void:
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size# Replace with function body.
