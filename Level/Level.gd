extends Node2D

onready var Hex = $TileMap
signal spawn_bubble
signal prepare_bubble

var PlayerLoc: Vector2
var matching_bubbles = []
var bubbles_checked = []

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
	check_remaining_bubbles()


func check_remaining_bubbles():
	var available_bubbles = []
	for bubble in number_of_bubble_types:
		available_bubbles.append(bubble)
	emit_signal("prepare_bubble", available_bubbles)


func bubble_stopped(pos, bubble, type):
	pos = $TileMap.world_to_map(pos)
	$TileMap.set_cell(pos.x, pos.y, type)
	bubble.queue_free()
	
	###check for matches
	matching_bubbles = [pos]
	bubbles_checked = []
	$Timer.start()
	check_neighbours(pos)


func check_neighbours(cell):
	bubbles_checked.append(cell)
	var neighbours = get_my_neighbours(cell)
	var used_cells = $TileMap.get_used_cells()
	for n in neighbours:
		if not bubbles_checked.has(cell+n) and used_cells.has(cell+n):
			if $TileMap.get_cellv(cell+n) == $TileMap.get_cellv(cell):
				matching_bubbles.append(cell+n)
				check_neighbours(cell+n)


func get_my_neighbours(cell):
	var neighbours = [
			Vector2(-1,-1), Vector2(0,-1),
			Vector2(-1,0), Vector2(1,0),
			Vector2(-1,1), Vector2(0,1)
			]
	var offset_neighbours = [
			Vector2(0,-1), Vector2(1,-1),
			Vector2(-1,0), Vector2(1,0),
			Vector2(0,1), Vector2(1,1)
		]
	if int(cell.y) %2:
		return offset_neighbours
	else:
		return neighbours


func _on_Timer_timeout():
	check_bubble_counter()


func check_bubble_counter():
	if matching_bubbles.size() > 2:
		# increment score
		for bubble in matching_bubbles:
			$TileMap.set_cellv(bubble, -1)






