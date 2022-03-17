extends Node2D

onready var Hex = $TileMap
signal spawn_bubble

var PlayerLoc: Vector2

const MAP_X = 19
const MAP_Y = 13

export (int, 2, 10) var number_of_bubble_types = 4

func _ready():
	randomize()
	for x in range (1,MAP_X):
		for y in floor(MAP_Y/2):
			var bubble_type = randi() % number_of_bubble_types
			Hex.set_cell(x,y,bubble_type)
	PlayerLoc = get_PlayerLoc()
	print(PlayerLoc)


func get_PlayerLoc():
	return $Player.global_position


func _on_Player_fire_bubble(angle):
	emit_signal("spawn_bubble", angle, PlayerLoc)
