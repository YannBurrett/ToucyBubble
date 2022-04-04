extends RigidBody2D

var type = 0 setget change_colour

signal bubble_stopped


func _ready():
	$Sprite.texture = GameState.bubble_sprites


func change_colour(number:int):
	type = number
	$Sprite.frame = type


func _on_Bubble_body_entered(body):
	if body.collision_layer > 1:
		lock_bubble()


func lock_bubble():
	emit_signal("bubble_stopped", position, self, type)


func _physics_process(_delta):
	if linear_velocity.y > 0:
		linear_velocity.y *= -1
