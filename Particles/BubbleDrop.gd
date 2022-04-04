extends Particles2D

var type = 0 setget change_colour


func _ready():
	texture = GameState.bubble_sprites


func drop_bubbles():
	$AnimationPlayer.play("Drop")


func change_colour(value):
	process_material.anim_offset = value * 0.1
