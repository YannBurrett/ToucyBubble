extends Node2D



func _on_ButtonNewGame_pressed():
	$CanvasLayer/Control/LevelSelect.popup_centered()


func _on_ButtonQuit_pressed():
	get_tree().quit()


func _on_Buttonoptions_pressed():
	$CanvasLayer/Control/OptionsMenu.popup_centered()


func _on_ButtonHighScore_pressed():
	$CanvasLayer/Control/HighScores.popup_centered()
