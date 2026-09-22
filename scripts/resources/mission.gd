# Ad Maiorem Dei Gloriam!
class_name Mission
extends Resource

@export var items: Array[MissionItem]
		
func is_completed() -> bool:
	return items.all(is_mission_item_completed)
	
func is_mission_item_completed(item: MissionItem) -> bool:
	return item.progress >= item.maximum
