extends KinematicBody2D
class_name character_base

export (int) var speed = 200
export (int) var gravity = 3200
export (int) var jump_power = 1200

var velocity = Vector2()

onready var animController = $AnimatedSprite

func _ready() -> void:
	animController.play()

func char_input(delta) -> float:
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += speed
	if Input.is_action_pressed("walk_left"):
		velocity.x -= speed
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	return velocity.x

func _on_AnimatedSprite_animation_finished() -> void:
	pass
