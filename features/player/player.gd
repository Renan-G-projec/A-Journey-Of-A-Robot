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



var facing_direction: int = 1

signal mined_block(tilemap_coords: Vector2i, damage: float)

var block_inventory: Dictionary[int, int]
var current_placing_block: int = 1

func _ready() -> void:
	EventBus.block_mined.connect(_on_block_mined)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


	jetpack.is_active = Input.is_action_pressed("UseJetpack")
	velocity.y += jetpack.get_jetpack_velocity(delta)
	
	if Input.is_action_pressed("MineFacingBlock"):
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
