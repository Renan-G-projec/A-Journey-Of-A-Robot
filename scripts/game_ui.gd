# Ad Maiorem Dei Gloriam!
extends CanvasLayer

# This script will just adjust the UI zoom accordingly with the camera.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    scale = get_viewport().get_camera_2d().zoom
