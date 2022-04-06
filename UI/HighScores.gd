extends Popup


func _ready():
	var scores = $VBoxContainer/CenterContainer/ScoreContainer.get_child_count()
	scores /= 2
	for score in scores:
		$VBoxContainer/CenterContainer/ScoreContainer.get_child((score*2)+1).text = str(GameState.highscores[score])



func _on_DoneButton_pressed():
	hide()
