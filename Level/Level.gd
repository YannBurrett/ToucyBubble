extends Node2D

onready var Hex = $TileMap
signal spawn_bubble
signal prepare_bubble

var PlayerLoc: Vector2
var matching_bubbles = []
var bubbles_checked = []

const MAP_X = 19
const MAP_Y = 13
const CELL_TYPE = 1

export (int, 2, 10) var number_of_bubble_types = 4

func _ready():
	randomize()
	for x in range (1,MAP_X):
		for y in floor(MAP_Y/2):
			var bubble_type = randi() % number_of_bubble_types
			Hex.set_cell(x,y,bubble_type)
	PlayerLoc = get_PlayerLoc()
	check_remaining_bubbles()


func get_PlayerLoc():
	return $Player.global_position


func _on_Player_fire_bubble(angle):
	emit_signal("spawn_bubble", angle, PlayerLoc)
	check_remaining_bubbles()


func check_remaining_bubbles():
	var bubbles = []
	var cells = $TileMap.get_used_cells()
	for cell in cells:
		bubbles.append([cell, $TileMap.get_cellv(cell)])
	var available_bubbles = []
	for bubble in bubbles:
		if not available_bubbles.has(bubble[CELL_TYPE]):
			available_bubbles.append(bubble[CELL_TYPE])
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
	check_detatched_bubbles()


func check_detatched_bubbles():
	var detached_bubbles = $TileMap.get_used_cells()
	
	bubbles_checked = []
	matching_bubbles = []
	
	### Mark top row of bubbles as attached
	for bubble_number in detached_bubbles.size():
		if detached_bubbles[bubble_number].y == 0:
			matching_bubbles.append(detached_bubbles[bubble_number])
	
	### Check for contiguous bubbles
	for cell in detached_bubbles:
		bubbles_checked.append(cell)
		var neighbours = get_my_neighbours(cell)
		for n in neighbours:
			if matching_bubbles.has(cell) and not bubbles_checked.has(cell+n):
				matching_bubbles.append(cell+n)
				

	###Remove detatched bubbles
	for bubble in detached_bubbles:
		if not matching_bubbles.has(bubble):
			$TileMap.set_cellv(bubble, -1)


