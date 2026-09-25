# Ad Maiorem Dei Gloriam!
class_name MenuManager
extends Control

enum MenuState {
	CLOSED,
	OPENING,
	OPEN,
	CLOSING
}

@export_range(0.0, 1.0, 0.01) var overlay_step: float = 0.08

@onready var overlay: ColorRect = $ColorRect
@onready var panel: Panel = $MenuPanel

@onready var panel_initial_x_scale: float = panel.scale.x
@onready var overlay_alpha: float = overlay.color.a

var state: MenuState = MenuState.CLOSED

@export var menus: Dictionary[EventBus.MenuType, Control]

func _ready() -> void:
	overlay.color.a = 0.0
	panel.scale.x = 0.0
	EventBus.request_open_menu.connect(_on_menu_requested)
	EventBus.request_close_menu.connect(_on_menu_close_requested)

func _on_menu_requested(type: EventBus.MenuType) -> void:
	if state != MenuState.OPEN:
		open_menu()
	set_current_menu(type)
	
func _on_menu_close_requested() -> void:
	close_menu()
	

func _process(_delta: float) -> void:
	match state:
		MenuState.OPENING:
			overlay.color.a = lerp(overlay.color.a, overlay_alpha, overlay_step)
			panel.scale.x = lerp(panel.scale.x, panel_initial_x_scale, overlay_step)
			if overlay.color.a >= overlay_alpha - 0.002 && panel.scale.x >= panel_initial_x_scale - 0.002:
				overlay.color.a = overlay_alpha
				panel.scale.x = panel_initial_x_scale
				state = MenuState.OPEN
				
		MenuState.CLOSING:
			overlay.color.a = lerp(overlay.color.a, 0.0, overlay_step)
			panel.scale.x = lerp(panel.scale.x, 0.0, overlay_step)
			if overlay.color.a <= 0.002 && panel.scale.x <= 0.002:
				overlay.color.a = 0.0
				panel.scale.x = 0.0
				state = MenuState.CLOSED

func open_menu() -> void:
	state = MenuState.OPENING

func close_menu() -> void:
	state = MenuState.CLOSING

func set_current_menu(type: EventBus.MenuType) -> void:
	for menu in menus:
		menus[menu].visible = menu == type
