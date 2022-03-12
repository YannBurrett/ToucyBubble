extends Node2D


func _ready():
	randomize()


func _unhandled_input(event):
	if event.is_action_pressed("Fire"):
		print("Fire")
	if event.is_action_pressed("Left"):
		print("Left")
	if event.is_action_pressed("Right"):
		print("Right")
	if event.is_action_pressed("Nudge_Left"):
		print("Nudge_Left")
	if event.is_action_pressed("Nudge_Right"):
		print("Nudge_Right")


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	var animations = ["blink", "flap", "look"]
	$AnimatedSprite.play(animations[randi() % animations.size()])


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "idle":
		$AnimatedSprite.play("idle")
