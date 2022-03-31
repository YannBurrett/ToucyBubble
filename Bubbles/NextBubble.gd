extends Node2D

signal next_bubble

func _on_Level_prepare_bubble(available_bubbles:Array):
	var type = available_bubbles[randi() % available_bubbles.size()]
	$ReadyBubble.frame = type
	emit_signal("next_bubble", type)


