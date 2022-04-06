extends Panel

var score = 0 setget update_score
signal updated_score

func update_score(new_score):
	$Tween.interpolate_property(
			$Label, "text",
			score, new_score, 
			.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_step(_object, _key, _elapsed, value):
	var current_score = stepify(value, 1.0)
	$Label.text = str(current_score)
	emit_signal("updated_score", current_score)


func _on_Tween_tween_all_completed():
	score = int($Label.text)
	emit_signal("updated_score", score)
