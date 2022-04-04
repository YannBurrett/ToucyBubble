extends TileMap

var blank_bubbles = preload("res://Bubbles/Blank_bubbles.tres")
var symbol_bubbles = preload("res://Bubbles/Symbol_bubbles.tres")

func _ready():
	check_tileset()


func check_tileset():
	if GameState.symbols_mode:
		tile_set = symbol_bubbles
	else:
		tile_set = blank_bubbles


func update_symbols(_symbols):
	check_tileset()
