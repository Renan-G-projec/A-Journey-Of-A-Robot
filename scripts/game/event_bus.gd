# Ad Maiorem Dei Gloriam!
extends Node
# This script is for defining global events without chaining everything up

enum MenuType {
	TECH_TREE,
	PAUSE
}

signal request_open_menu(type: MenuType)
