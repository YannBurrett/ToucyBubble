extends Particles2D

func _ready():
	texture = GameState.bubble_sprites


func update_symbols(bubbles):
	texture = bubbles
