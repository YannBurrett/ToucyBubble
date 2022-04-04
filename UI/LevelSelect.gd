extends Popup



func _on_GoButton_pressed():
	GameState.difficulty = int($Panel/CenterContainer/HBoxContainer/SpinBox.value)
	get_tree().change_scene("res://Level/Level.tscn")
