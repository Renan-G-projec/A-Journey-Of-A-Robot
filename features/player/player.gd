# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -400.0
@export var inventory: Inventory

@onready var drill: Drill = $Drill
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var jetpack: Jetpack = $Jetpack
@onready var block_placer: BlockPlacer = $%BlockPlacer

var _was_on_ground: bool = false
var _prev_y_velocity: float = 0.0

var facing_direction: int = 1

signal mined_block(tilemap_coords: Vector2i, damage: float)
signal placed_machine(tile: Vector2i, machine: Node2D)

var block_inventory: Dictionary[int, int]
var current_placing_block: int = 1

var is_building: bool = false
var current_placing_scene: Node2D = null
var current_placing_location: Vector2i = Vector2.ZERO

func _ready() -> void:
	EventBus.block_mined.connect(_on_block_mined)
	EventBus.enter_build_mode.connect(_enter_building_state)
	EventBus.exit_build_mode.connect(_exit_building_state)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif !_was_on_ground:
		_squash(velocity.y / 1000)
	if !Global.in_dialogue && Global.can_move:
		_update_inputs(delta)
	if is_building:
		_update_ui_inputs()

	jetpack.boost = is_on_floor()
	_was_on_ground = is_on_floor()
	_prev_y_velocity = velocity.y
	
	move_and_slide()
	update_state()

func _on_driil_mined_block(tilemap_position: Vector2i, damage: float) -> void:
	mined_block.emit(tilemap_position, damage)
	
func update_state() -> void:
	var going_direction: int = Input.get_axis("GoLeft", "GoRight")
	if going_direction < 0:
		sprite.play("runningLeft")
		facing_direction = going_direction
	elif going_direction > 0:
		sprite.play("runningRight")
		facing_direction = going_direction
	else:
		if (facing_direction < 0): sprite.play("idleLeft")
		else: sprite.play("idleRight")

func _on_block_mined(block_type: int) -> void:
	block_inventory[block_type] = 1 + block_inventory.get(block_type, 0)

func _update_inputs(delta: float) -> void:
	jetpack.is_active = Input.is_action_pressed("UseJetpack")
	velocity.y += jetpack.get_jetpack_velocity(delta)
	
	if Input.is_action_pressed("MineFacingBlock"):
		if !Global.can_mine: return
		if (drill.is_facing_block): drill.start_emitting_particles()
		drill.mine()
	else:
		drill.stop_emitting_particles()
	if !(drill.is_facing_block): drill.stop_emitting_particles()
	
	var direction := Input.get_axis("GoLeft", "GoRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("PutFacingBlock") && block_inventory.get(current_placing_block, 0) > 0:
		block_inventory[current_placing_block] -= 1
		block_placer.place_block(current_placing_block)

func _update_ui_inputs() -> void:
	if Input.is_action_just_pressed("BuildingModeGoRight"): current_placing_location.x += 1
	if Input.is_action_just_pressed("BuildingModeGoLeft"): current_placing_location.x -= 1
	if Input.is_action_just_pressed("BuildingModeGoUp"): current_placing_location.y -= 1
	if Input.is_action_just_pressed("BuildingModeGoDown"): current_placing_location.y += 1
	if Input.is_action_just_pressed("ui_cancel"):
		EventBus.exit_build_mode.emit()
		current_placing_scene.queue_free()
	if Input.is_action_just_pressed("ui_accept"):
		current_placing_scene.modulate.a = 1.0
		placed_machine.emit(current_placing_location, current_placing_scene)
		current_placing_scene = null
		EventBus.exit_build_mode.emit()
		return
	_update_ui_location()

func _update_ui_location() -> void:
	$Camera2D.global_position = Vector2(current_placing_location.x * 16.0, current_placing_location.y * 16)
	if (current_placing_scene):
		current_placing_scene.global_position = Vector2(current_placing_location.x * 16.0, current_placing_location.y * 16)

func _squash(power: float) -> void:
	$Sprite.scale = Vector2(1.4 + power, 0.6 - power)
	var tween := create_tween()
	tween.tween_property($Sprite, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_QUAD)

func _enter_building_state(building: PackedScene) -> void:
	current_placing_scene = building.instantiate()
	current_placing_scene.modulate.a = 0.7
	add_child(current_placing_scene)
	is_building = true

func _exit_building_state() -> void:
	is_building = false
	current_placing_scene = null
	$Camera2D.position = Vector2.ZERO
