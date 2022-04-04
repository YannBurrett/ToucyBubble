extends Popup



func _on_DoneButton_pressed():
	hide()


func _on_FullscreenButton_pressed():
	GameState.fullscreen = !GameState.fullscreen



func _on_SoundSlider_value_changed(value):
	pass # Replace with function body.


func _on_MusicSlider_value_changed(value):
	pass # Replace with function body.


func _on_SymbolButton_toggled(button_pressed):
	GameState.symbols_mode = button_pressed
