extends Node2D

onready var Hex = $TileMap

const MAP_X = 19
const MAP_Y = 13

export (int, 2, 10) var number_of_bubble_types = 4

func _ready():
	randomize()
	for x in range (1,MAP_X):
		for y in floor(MAP_Y/2):
			var bubble_type = randi() % number_of_bubble_types
			Hex.set_cell(x,y,bubble_type)
