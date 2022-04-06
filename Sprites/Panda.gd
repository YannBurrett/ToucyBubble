extends AnimatedSprite

var panicking = false


func _on_Level_game_over(has_won):
	if has_won:
		play("win")
	else:
		play("lose")


func _on_Level_panic(should_panic):
	if should_panic:
		play("panic")
	else:
		play("idle")
	panicking = should_panic


func _on_Timer_timeout():
	play("wave")


func _on_Panda_animation_finished():
	if not panicking:
		play("idle")
