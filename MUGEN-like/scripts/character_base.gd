extends KinematicBody2D
class_name character_base

export (int) var speed = 200
export (int) var gravity = 3400
export (int) var jump_power = 1000

var velocity = Vector2()

onready var animController = $AnimatedSprite

func _ready() -> void:
	#Engine.time_scale = 0.5
	animController.play()


func char_input(delta) -> float:
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += 1 * speed
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1 * speed
	
	velocity.y += gravity * delta
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP, true)
	
	return velocity.x

func motion(delta):
	velocity.y += gravity * delta
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP, true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_AnimatedSprite_animation_finished() -> void:
	match (animController.animation):
		"jump":
			animController.animation = "jump_loop"
		"jump_forwards":
			animController.animation = "jump_forwards_loop"
		"jump_backwards":
			animController.animation = "jump_backwards_loop"
