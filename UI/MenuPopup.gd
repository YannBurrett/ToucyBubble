extends Popup

var score = 0

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()


func _on_MenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_OptionsButton_pressed():
	$OptionsMenu.popup_centered()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	hide()

func _on_MenuPopup_visibility_changed():
	get_tree().call_group("Player", "set_fire", !visible)


func game_over(has_won):
	if has_won:
		$Panel/VBoxContainer/TitleLabel.text = "Victory!"
	else:
		$Panel/VBoxContainer/TitleLabel.text = "Game Over!"
	
	$Panel/VBoxContainer/ScoreLabel.show()
	
	popup_centered()
	if GameState.check_highscore(score):
		$Panel/HighScoreLabel.show()



func _on_Score_updated_score(new_score):
	score = new_score
	$Panel/VBoxContainer/ScoreLabel.text = "Your Score: %s" %score
