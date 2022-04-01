extends Node2D

const MAX_ANGLE = 70
const ROTATION_SPEED = 1

signal fire_bubble

var can_fire = true

func _ready():
	randomize()


func _process(_delta):
	var rot = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	if abs($Aimer.rotation_degrees + rot * ROTATION_SPEED) <= MAX_ANGLE:
		$Aimer.rotation_degrees += rot * ROTATION_SPEED
	
	var AimLine_distance_1 = position.distance_to($Aimer/RayCast2D.get_collision_point())
	var AimLine_distance_2 = position.distance_to($Aimer/RayCast2D2.get_collision_point())
	
	var aim_target = min(AimLine_distance_1, AimLine_distance_2)
	$AimeLine.points[0] = Vector2(0,-aim_target).rotated($Aimer.rotation)


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
	if can_fire:
		emit_signal("fire_bubble", $Aimer.rotation)
		can_fire = false
		$AimeLine.hide()


func set_fire(value):
	can_fire = value
	$AimeLine.show()

