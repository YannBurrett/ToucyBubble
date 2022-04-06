extends Popup


func _ready():
	$Panel/VBoxContainer/MusicSlider.value = GameState.music_volume
	$Panel/VBoxContainer/SoundSlider.value = GameState.sfx_volume
	$Panel/VBoxContainer/CenterContainer/GridContainer/FullscreenButton.pressed = GameState.fullscreen
	$Panel/VBoxContainer/CenterContainer/GridContainer/SymbolButton.pressed = GameState.symbols_mode


func _on_DoneButton_pressed():
	hide()


func _on_FullscreenButton_pressed():
	GameState.fullscreen = !GameState.fullscreen


func _on_SoundSlider_value_changed(value):
	GameState.sfx_volume = value


func _on_MusicSlider_value_changed(value):
	GameState.music_volume = value


func _on_SymbolButton_toggled(button_pressed):
	GameState.symbols_mode = button_pressed
