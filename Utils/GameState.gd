extends Node

export (int) var difficulty = 4
export (bool) var fullscreen = false setget set_fullscreen

var symbols_mode :bool = true setget set_symbols_mode

var blank_sprites = preload("res://Sprites/BubbleSpriteSheet.png")
var symbol_sprites = preload("res://Sprites/BubbleSpriteSheet2.png")

var bubble_sprites = symbol_sprites


func set_fullscreen(is_fullscreen):
	fullscreen = is_fullscreen
	OS.window_fullscreen = is_fullscreen


func set_symbols_mode(symbols):
	symbols_mode = symbols
	if symbols:
		bubble_sprites = symbol_sprites
	else:
		bubble_sprites = blank_sprites
	get_tree().call_group("Bubbles", "update_symbols", bubble_sprites)
