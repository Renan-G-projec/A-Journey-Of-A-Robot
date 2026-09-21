# Ad Maiorem Dei Gloriam!
@tool
extends Node2D

enum MachineState {
	FREE,
	PROCESSING,
	FULL
}
@export var state: MachineState = MachineState.FREE
@export var data: Machine:
	set(value):
		data = value
		machine_processing_time = value.process_time;
		machine_processing_timer = machine_processing_time
		update_editor_sprite()

@onready var sprite: Sprite2D = $Sprite2D
@onready var input_panel: Panel = $InputPanel

var in_inv: Inventory = null
var out_inv: Inventory = null
var listening_for_input: bool = false;
var machine_processing_time: float = 0
var machine_processing_timer: float = machine_processing_time

func update_editor_sprite() -> void:
	if sprite and data and data.texture:
		sprite.texture = data.texture

func _ready() -> void:
	input_panel.visible = false
	
# The collision mask assures that only the player layer will trigger these signals
func _on_area_2d_body_entered(body: Node2D) -> void:
	input_panel.visible = true;
	
	listening_for_input = body is Player
	
	var player: Player = body as Player
	if player:
		in_inv = player.inventory
		out_inv = player.inventory


func _on_area_2d_body_exited(body: Node2D) -> void:
	input_panel.visible = false;

	listening_for_input = !(body is Player)
	
	in_inv = null
	out_inv = null

func take_input_resources() -> void:
	if !in_inv || state != MachineState.FREE: return
	
	var items_to_remove: Inventory = Inventory.new()
	for item in data.input.data:
		if in_inv.get_item(item) >= data.input.get_item(item):
			items_to_remove.add_item(item, data.input.get_item(item))
		else:
			return
	state = MachineState.PROCESSING
	
	in_inv.remove_items(items_to_remove)

func put_output_resources() -> void:
	if !out_inv || state != MachineState.FULL: return
	state = MachineState.FREE
	
	out_inv.add_items(data.output)
	
func update_input() -> void:
	if listening_for_input:
		if Input.is_action_just_pressed("Interact"):
			match state:
				MachineState.FREE:
					take_input_resources()
				MachineState.FULL:
					put_output_resources()

func update_processing_time(delta: float) -> void:
	if state != MachineState.PROCESSING: return
	machine_processing_timer -= delta
	if machine_processing_timer <= 0.0:
		state = MachineState.FULL
		machine_processing_timer = machine_processing_time

func _process(delta: float) -> void:
	update_input()
	update_processing_time(delta)
