extends Node2D

@onready var children: Array[Node] = find_children("Nebula*")
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@export var groundY: int = 180 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if (!camera): return
    
    var cameraDiff: float = camera.global_position.y - groundY
    for c in children:
        if c is Parallax2D:
            if (cameraDiff < 0):
                c.scroll_offset.y = c.scroll_scale.x * -cameraDiff
            else:
                c.scroll_offset.y = -cameraDiff 
