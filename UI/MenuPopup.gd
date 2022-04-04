extends Popup



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
