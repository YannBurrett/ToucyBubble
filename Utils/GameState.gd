extends Node

export (int) var difficulty = 4 setget set_difficulty
export (bool) var fullscreen = false setget set_fullscreen

export (int, -10,0) var music_volume = -3 setget set_music_volume
export (int, -10,0) var sfx_volume = -3 setget set_sfx_volume

var config = ConfigFile.new()
const CONFIG_FILE = "user://settings.cfg"

var symbols_mode :bool = true setget set_symbols_mode

var blank_sprites = preload("res://Sprites/BubbleSpriteSheet.png")
var symbol_sprites = preload("res://Sprites/BubbleSpriteSheet2.png")

var bubble_sprites = symbol_sprites
var highscores = [1,2,3,4,5,6,7,8,9,10]

var default_settings = {
		"audio":
			{"music_volume":-3, "sfx_volume": -3},
		"video":
			{"fullscreen": false, "symbols": false},
		"game" :
			{"difficulty": 4, "highscores": [1,2,3,4,5,6,7,8,9,10]}
		}

var settings = {
		"audio":
			{"music_volume":null, "sfx_volume": null},
		"video":
			{"fullscreen": null, "symbols": null},
		"game" :
			{"difficulty": null, "highscores": null}
		}


func _ready():
	load_settings()
	music_volume = settings["audio"]["music_volume"]
	set_music_volume(music_volume)
	sfx_volume = settings["audio"]["sfx_volume"]
	set_sfx_volume(sfx_volume)
	highscores = settings["game"]["highscores"]
	highscores.sort_custom(self, "sort_scores")
	fullscreen = settings["video"]["fullscreen"]
	set_fullscreen(fullscreen)
	symbols_mode = settings["video"]["symbols"]
	set_symbols_mode(symbols_mode)
	difficulty = settings["game"]["difficulty"]
	set_difficulty(difficulty)


func sort_scores(a,b):
	if a>b:
		return true
	else:
		return false



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


func check_highscore(new_score):
	for score in highscores:
		if new_score > score:
			highscores.pop_back()
			highscores.push_back(new_score)
			highscores.sort_custom(self, "sort_scores")
			settings["game"]["highscores"] = highscores
			save_settings()
			return true
	return false


func set_music_volume(volume):
	if volume == -10:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1, -10 + volume)
	music_volume = volume
	settings["audio"]["music_volume"] = volume
	save_settings()


func set_sfx_volume(volume):
	if volume == -10:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		AudioServer.set_bus_volume_db(2, -10 + volume)
	sfx_volume = volume
	settings["audio"]["sfx_volume"] = volume
	save_settings()








