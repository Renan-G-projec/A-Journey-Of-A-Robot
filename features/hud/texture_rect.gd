# Ad Maiorem Dei Gloriam!
extends TextureRect

@export var parallax_velocity: float = 20.0
var _initial_size: Vector2

func _ready() -> void:
	_initial_size = size
	size.x = size.x * 2.0
	size.y = size.y * 2.0

func _process(delta: float) -> void:
	position.x -= delta * parallax_velocity
	if position.x <= -_initial_size.x:
		position.x = -delta * 2 * parallax_velocity
	position.y -= delta * parallax_velocity
	if position.y <= -_initial_size.y:
		position.y = -delta * 2 * parallax_velocity
