extends RigidBody2D

var type = 0 setget change_colour


func change_colour(number:int):
	type = number
	$Sprite.frame = type


