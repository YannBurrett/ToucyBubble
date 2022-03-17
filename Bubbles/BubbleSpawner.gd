extends Node2D

var Bubble = preload("res://Bubbles/Bubble.tscn")
const SPEED = 500


func _on_Level_spawn_bubble(angle, location):
	var new_Bubble = Bubble.instance()
	new_Bubble.global_position = location
	add_child(new_Bubble)
	new_Bubble.apply_central_impulse(-Vector2(0,1).rotated(angle) * SPEED)

