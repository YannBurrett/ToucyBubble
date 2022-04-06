extends Node2D

var number_of_available_bubble_types = 4 setget prepare_first_bubble
signal next_bubble
var type = 0


func _ready():
	$BubbleOnDeck.texture = GameState.bubble_sprites
	$ReadyBubble.texture = GameState.bubble_sprites


func prepare_first_bubble(number_of_types):
	$ReadyBubble.frame = randi() % number_of_types
	$ReadyBubble.visible = false
	$BubbleOnDeck.frame = $ReadyBubble.frame
	type = randi() % number_of_types
	emit_signal("next_bubble", $ReadyBubble.frame)
	$AnimationPlayer.play("BubbleOnDeck")



func _on_Level_prepare_bubble(available_bubbles:Array):
	if available_bubbles.size() == 0:
		return
	type = available_bubbles[randi() % available_bubbles.size()]
	$ReadyBubble.frame = $BubbleOnDeck.frame
	emit_signal("next_bubble", $ReadyBubble.frame)
	$AnimationPlayer.play("BubbleOnDeck")


func update_symbols(sprite):
	$BubbleOnDeck.texture = sprite
	$ReadyBubble.texture = sprite


func reset_on_deck_colour():
	$BubbleOnDeck.frame = type
