# Ad Maiorem Dei Gloriam!
extends Node
# This script is for defining global events without chaining everything up

enum MenuType {
	MAINBASE,
	TECH_TREE,
	CRAFTING,
	BUILDING, 
	PAUSE
}

signal request_open_menu(type: MenuType)
signal request_close_menu()
signal request_comming_soon_popup()

signal request_start_dialogue_sequence(dialogue_sequence: DialogueSequence)

signal block_mined(block_type: int)
signal chunk_loaded()
