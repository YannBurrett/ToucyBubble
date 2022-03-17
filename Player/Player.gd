extends Node2D

const MAX_ANGLE = 70
const ROTATION_SPEED = 1

signal fire_bubble

func _ready():
	randomize()


func _process(_delta):
	var rot = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	if abs($Aimer.rotation_degrees + rot * ROTATION_SPEED) <= MAX_ANGLE:
		$Aimer.rotation_degrees += rot * ROTATION_SPEED


func _unhandled_input(event):
	if event.is_action_pressed("Fire"):
		fire()
	if event.is_action_pressed("Nudge_Left"):
		if abs($Aimer.rotation_degrees -1) <= MAX_ANGLE:
			$Aimer.rotation_degrees -= 1
	if event.is_action_pressed("Nudge_Right"):
		if abs($Aimer.rotation_degrees +1) <= MAX_ANGLE:
			$Aimer.rotation_degrees += 1


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	var animations = ["blink", "flap", "look"]
	$AnimatedSprite.play(animations[randi() % animations.size()])


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "idle":
		$AnimatedSprite.play("idle")


func fire():
	emit_signal("fire_bubble", $Aimer.rotation)
