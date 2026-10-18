# Ad Maiorem Dei Gloriam!
class_name EventBusClass
extends Node
# This script is for defining global events without chaining everything up
enum MenuType {
	PAUSE,
}

signal request_open_menu(menu_type: MenuType)

signal request_start_dialogue_sequence(dialogue_sequence: DialogueSequence)

signal block_mined(block_type: int)
signal chunk_loaded()

signal enter_build_mode(building: PackedScene)
signal exit_build_mode()
