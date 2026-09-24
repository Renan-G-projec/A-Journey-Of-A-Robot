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

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var panel: InputPanel = $InputPanel

var in_inv: Inventory = null
var out_inv: Inventory = null
var listening_for_input: bool = false;
var machine_processing_time: float = 0
var machine_processing_timer: float = machine_processing_time

func update_editor_sprite() -> void:
	if sprite and data and data.sprite:
		sprite.sprite_frames = data.sprite

func _ready() -> void:
	panel.visible = false
	sync_sprite_with_state()
	update_editor_sprite()
	
	for input in data.input.data:
		panel.add_input(input, data.input.data[input])
	
# The collision mask assures that only the player layer will trigger these signals
func _on_area_2d_body_entered(body: Node2D) -> void:
	panel.visible = true;
	
	listening_for_input = body is Player
	
	var player: Player = body as Player
	if player:
		in_inv = player.inventory
		out_inv = player.inventory


func _on_area_2d_body_exited(body: Node2D) -> void:
	panel.visible = false;

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
	set_state(MachineState.PROCESSING)
	
	in_inv.remove_items(items_to_remove)

func put_output_resources() -> void:
	if !out_inv || state != MachineState.FULL: return
	set_state(MachineState.FREE)
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
		set_state(MachineState.FULL)
		machine_processing_timer = machine_processing_time
		
func sync_sprite_with_state() -> void:
	match state:
		MachineState.FREE:
			sprite.play("free")
		MachineState.PROCESSING:
			sprite.play("processing")
		MachineState.FULL:
			sprite.play("full")

func set_state(new_state: MachineState) -> void:
	state = new_state
	sync_sprite_with_state()

func _process(delta: float) -> void:
	update_input()
	update_processing_time(delta)
