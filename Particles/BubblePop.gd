extends Particles2D

var type = 0 setget change_colour

func change_colour(value):
	process_material.anim_offset = value * 0.1


func pop_bubbles():
	$AnimationPlayer.play("Pop")
