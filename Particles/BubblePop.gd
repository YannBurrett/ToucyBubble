extends Particles2D

export (Array, Resource) var pops
var type = 0 setget change_colour

func _ready():
	texture = GameState.bubble_sprites


func change_colour(value):
	process_material.anim_offset = value * 0.1


func pop_bubbles():
	$BubblePopSFX.stream = pops[randi() % pops.size()]
	$BubblePopSFX.play()
	$AnimationPlayer.play("Pop")
