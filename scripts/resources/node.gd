extends Button

@export var coal_ore := preload("res://resources/items/coal_ore.tres") as InventoryItem 
@export var iron_ore := preload("res://resources/items/iron_ore.tres") as InventoryItem
@export var copper_ore := preload("res://resources/items/copper_ore.tres") as InventoryItem
@onready var player_stage_1: Button = $"."

var inventory := preload("res://resources/inventories/player_inventory.tres") as Inventory

var coal_ore_count: int = 0 
var iron_ore_count: int = 0
var copper_ore_count: int = 0

var coal_ore_cost: int = 0
var iron_ore_cost: int = 0
var coppor_ore_cost: int = 0

var neighbors: Array = [] : set = set_neighbors
var lines : Array = []
var neighbor_lines : Array = []

func add_line(neighbor: Button) -> void:
	var line: Line2D = Line2D.new()
	line.width = 2
	line.z_index = -1
	line.add_point(global_position + size / 2)
	line.add_point(neighbor.global_position + neighbor.size/2)
	lines.push_back(line)
	neighbor.neighbor_lines.push_back(line)
	get_parent().add_child(line)

func update_lines() -> void:
	for line: Line2D in lines:
		line.set_point_position(0, global_position + size/2)
	for line: Line2D in neighbor_lines:
		line.set_point_position(1, global_position + size / 2)

func set_neighbors (new_neighbors: Array) -> void:
	for neighbor: Button in new_neighbors:
		if not neighbors.has(neighbor):
			add_line(neighbor)
	neighbors = new_neighbors
	 

func _process(delta: float) -> void:
	update_lines() 


func _on_toggled(toggled_on: bool) -> void:
	print("NAME", self.name)
	if self.name == "player_stage1":
		coal_ore_cost = 2
		iron_ore_cost = 0
		coppor_ore_cost = 0
	elif self.name == "drill_stage1":
		coal_ore_cost = 0
		iron_ore_cost = 2
		coppor_ore_cost = 0
	elif self.name == "furnance_stage1":
		coal_ore_cost = 0
		iron_ore_cost = 0
		coppor_ore_cost = 2

	if toggled_on and coal_ore_count > coal_ore_cost and iron_ore_count > iron_ore_cost and copper_ore_count > coppor_ore_cost:
		for neighbor: Button in neighbors: 
			neighbor.disabled = false
		self.disabled = true
		inventory.remove_item(coal_ore,coal_ore_cost)
		inventory.remove_item(iron_ore,iron_ore_cost)
		inventory.remove_item(copper_ore,coppor_ore_cost)
	
		
func _ready() -> void:

	if inventory != null:
		print("Inventory Loaded")
		inventory.inventory_item_changed.connect(on_inventory_change)

func on_inventory_change(item: InventoryItem, new_qtd: int) -> void:
	if item == coal_ore:
		coal_ore_count = new_qtd
	elif item == iron_ore:
		iron_ore_count = new_qtd
	elif item == copper_ore:
		copper_ore_count = new_qtd
