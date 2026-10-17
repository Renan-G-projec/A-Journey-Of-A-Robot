# Ad Maiorem Dei Gloriam!
extends Node
# This script is for defining global events without chaining everything up

signal request_start_dialogue_sequence(dialogue_sequence: DialogueSequence)

signal block_mined(block_type: int)
signal chunk_loaded()

signal enter_build_mode(building: PackedScene)
signal exit_build_mode()
