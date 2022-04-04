extends Popup


func _ready():
	$Panel/CenterContainer/HBoxContainer/SpinBox.value = GameState.difficulty

func _on_GoButton_pressed():
	GameState.difficulty = int($Panel/CenterContainer/HBoxContainer/SpinBox.value)
	get_tree().change_scene("res://Level/Level.tscn")
