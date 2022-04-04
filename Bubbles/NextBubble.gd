extends Node2D

var number_of_available_bubble_types = 4 setget prepare_first_bubble
signal next_bubble


func _ready():
	$BubbleOnDeck.texture = GameState.bubble_sprites
	$ReadyBubble.texture = GameState.bubble_sprites


func prepare_first_bubble(number_of_types):
	$ReadyBubble.frame = randi() % number_of_types
	$BubbleOnDeck.frame = randi() % number_of_types
	emit_signal("next_bubble", $ReadyBubble.frame)


func _on_Level_prepare_bubble(available_bubbles:Array):
	var type = available_bubbles[randi() % available_bubbles.size()]
	$ReadyBubble.frame = $BubbleOnDeck.frame
	$BubbleOnDeck.frame = type
	emit_signal("next_bubble", $ReadyBubble.frame)


func update_symbols(sprite):
	$BubbleOnDeck.texture = sprite
	$ReadyBubble.texture = sprite
