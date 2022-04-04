extends Node

export (int) var difficulty = 4 setget set_difficulty
export (bool) var fullscreen = false setget set_fullscreen

var config = ConfigFile.new()
const CONFIG_FILE = "user://settings.cfg"

var symbols_mode :bool = true setget set_symbols_mode

var blank_sprites = preload("res://Sprites/BubbleSpriteSheet.png")
var symbol_sprites = preload("res://Sprites/BubbleSpriteSheet2.png")

var bubble_sprites = symbol_sprites

var default_settings = {
		"video":
			{"fullscreen": false, "symbols": false},
		"game" :
			{"difficulty": 4}
		}

var settings = {
		"video":
			{"fullscreen": null, "symbols": null},
		"game" :
			{"difficulty": null}
		}


func _ready():
	load_settings()
	fullscreen = settings["video"]["fullscreen"]
	set_fullscreen(fullscreen)
	symbols_mode = settings["video"]["symbols"]
	set_symbols_mode(symbols_mode)
	difficulty = settings["game"]["difficulty"]
	set_difficulty(difficulty)
	


func set_fullscreen(is_fullscreen):
	fullscreen = is_fullscreen
	OS.window_fullscreen = is_fullscreen
	settings["video"]["fullscreen"] = fullscreen
	save_settings()


func set_symbols_mode(symbols):
	symbols_mode = symbols
	if symbols:
		bubble_sprites = symbol_sprites
	else:
		bubble_sprites = blank_sprites
	get_tree().call_group("Bubbles", "update_symbols", bubble_sprites)
	settings["video"]["symbols"] = symbols_mode
	save_settings()


func load_settings():
	var error = config.load(CONFIG_FILE)
	if error != OK:
		make_default_config_file()
	
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = config.get_value(section, key, default_settings[section][key])
	
	save_settings()


func make_default_config_file():
	config.save(CONFIG_FILE)


func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(CONFIG_FILE)


func set_difficulty(new_difficulty):
	difficulty = new_difficulty
	settings["game"]["difficulty"] = difficulty
	save_settings()




