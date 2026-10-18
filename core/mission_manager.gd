# Ad Maiorem Dei Gloriam!
## AUTOLOAD: Mission Manager
extends Node

var current_mission: Mission = null:
	set(val):
		current_mission = val
		changed_mission.emit(val)
		
		if val:
			current_mission.changed.connect(_on_current_mission_changed)
			current_mission.completed.connect(_on_current_mission_completed)

@export_file_path("res://features/missions/data/*") var next_mission: String

signal completed_mission(mission: Mission)
signal changed_mission(mission: Mission)


func _ready() -> void:
	current_mission = load("res://features/missions/data/initial_mission.gd").new()

func _on_current_mission_changed() -> void:
	changed_mission.emit(current_mission)

func _on_current_mission_completed() -> void:
	completed_mission.emit(current_mission)
	if (next_mission):
		current_mission = load(next_mission).new()
		next_mission = ""
	else:
		current_mission = null
