extends Node2D


func _ready():
	randomize()


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	var animations = ["blink", "flap", "look"]
	$AnimatedSprite.play(animations[randi() % animations.size()])


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "idle":
		$AnimatedSprite.play("idle")
