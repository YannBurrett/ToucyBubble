extends Node2D

var Bubble = preload("res://Bubbles/Bubble.tscn")
var next_bubble_type = 0

const SPEED = 500


func _on_Level_spawn_bubble(angle, location):
	$BubbleSFXPlayer.play()
	var new_Bubble = Bubble.instance()
	new_Bubble.type = next_bubble_type
	new_Bubble.global_position = location
	add_child(new_Bubble)
	new_Bubble.apply_central_impulse(-Vector2(0,1).rotated(angle) * SPEED)
	new_Bubble.connect("bubble_stopped", get_parent(), "bubble_stopped")



func _on_NextBubble_next_bubble(type):
	next_bubble_type = type
