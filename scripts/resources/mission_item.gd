# Ad Maiorem Dei Gloriam!
class_name MissionItem
extends Resource

@export var content: String
@export var progress: int
@export var maximum: int

signal changed_progress(new_progress: int)

func set_progress(new_progress: int) -> void:
	progress = new_progress
	changed_progress.emit(new_progress)
