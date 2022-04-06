extends Node2D

onready var Hex = $TileMap
signal spawn_bubble
signal prepare_bubble
signal can_fire
signal game_over
signal panic

var PlayerLoc: Vector2
var matching_bubbles = []
var bubbles_checked = []
var spawn_counter = 0

var bubbles_to_score = 0

const MAP_X = 19
const MAP_Y = 13
const CELL_TYPE = 1
const SPAWN_LIMIT = 10

export (int, 2, 10) var number_of_bubble_types = 4

var bubble_pop_particle = preload("res://Particles/BubblePop.tscn")
var bubble_drop_particle = preload("res://Particles/BubbleDrop.tscn")

func _ready():
	number_of_bubble_types = GameState.difficulty
	randomize()
	for x in range (1,MAP_X):
		for y in floor(MAP_Y/2):
			var bubble_type = randi() % number_of_bubble_types
			Hex.set_cell(x,y,bubble_type)
	PlayerLoc = get_PlayerLoc()
	$NextBubble.number_of_available_bubble_types = number_of_bubble_types


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
	pos = $TileMap.to_local(pos)
	pos = $TileMap.world_to_map(pos)
	$TileMap.set_cell(pos.x, pos.y, type)
	bubble.queue_free()
	
	check_game_over()
	
	###check for matches
	matching_bubbles = [pos]
	bubbles_checked = []
	$Timer.start()
	check_neighbours(pos)
	spawn_counter += 1


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
	check_spawn_counter()
	emit_signal("can_fire", true)
	$CanvasLayer/Score.score += bubbles_to_score
	bubbles_to_score = 0
	check_game_over()



func check_bubble_counter():
	if matching_bubbles.size() > 2:
		bubbles_to_score += 3 + ((matching_bubbles.size() -3)*2)
		for bubble in matching_bubbles:
			var pop = bubble_pop_particle.instance()
			add_child(pop)
			pop.position = $TileMap.to_global($TileMap.map_to_world(bubble) + Vector2(16,16))
			pop.type = $TileMap.get_cellv(bubble)
			pop.add_to_group("pop")
			$TileMap.set_cellv(bubble, -1)
		get_tree().call_group("pop", "pop_bubbles")
	check_detatched_bubbles()
	check_panic()


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
			var drop = bubble_drop_particle.instance()
			add_child(drop)
			drop.position = $TileMap.to_global($TileMap.map_to_world(bubble) + Vector2(16,16))
			drop.type = $TileMap.get_cellv(bubble)
			$TileMap.set_cellv(bubble, -1)
			bubbles_to_score += number_of_bubble_types * 2
	get_tree().call_group("Drop", "drop_bubbles")


func check_spawn_counter():
	if spawn_counter == SPAWN_LIMIT:
		move_ceiling_down()


func move_ceiling_down():
	$BubbleTween.interpolate_property($TileMap, "position",
			$TileMap.position, $TileMap.position + Vector2(0,27),
			0.5,
			$BubbleTween.TRANS_ELASTIC,
			Tween.EASE_IN_OUT
			)
	$BubbleTween.start()
	$CeilingTween.interpolate_property($Ceiling, "position",
			$Ceiling.position, $Ceiling.position + Vector2(0,27),
			0.5,
			$CeilingTween.TRANS_ELASTIC,
			Tween.EASE_IN_OUT
			)
	$CeilingTween.start()
	spawn_counter = 0



func game_over(has_won):
	if $Player:
		$Player.queue_free()
		$NextBubble.queue_free()
	$UILayer/MenuPopup.game_over(has_won)
	emit_signal("game_over", has_won)



func check_game_over():
	var bubbles = $TileMap.get_used_cells()

	if bubbles.size() == 0: 
		game_over(true)
		return
	
	var finish_line = $TileMap.to_local(Vector2(0,350))
	finish_line = $TileMap.world_to_map(finish_line)
	finish_line = finish_line.y
	
	for bubble in bubbles:
		if bubble.y >= finish_line:
			game_over(false)


func _on_BubbleTween_tween_all_completed():
	check_game_over()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and not $UILayer/MenuPopup.visible:
		$UILayer/MenuPopup.popup_centered()


func check_panic():
	var should_panic = false
	var bubbles = $TileMap.get_used_cells()
	var panic_line = $TileMap.to_local(Vector2(0,323))
	panic_line = $TileMap.world_to_map(panic_line)
	panic_line = panic_line.y
	
	for bubble in bubbles:
		if bubble.y >= panic_line:
			should_panic = true
	
	emit_signal("panic", should_panic)






