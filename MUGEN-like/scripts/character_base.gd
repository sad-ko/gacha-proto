extends KinematicBody2D
class_name character_base

export (int) var speed = 200
export (int) var gravity = 3200
export (int) var jump_power = 1000

var velocity = Vector2()
var height : float = 0.0

onready var animController = $AnimatedSprite
onready var animShadow = $CanvasLayer/Shadow
onready var canvas = $CanvasLayer

func _ready() -> void:
	animController.play()
	#canvas.offset = self.position

func _process(_delta: float) -> void:
	canvas.offset.x = self.position.x
	if velocity.y < 0:
		canvas.offset.y += 1.5
	elif not is_on_floor() and velocity.y > 0: 
		canvas.offset.y -= 1.5
	else: canvas.offset.y = self.position.y


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
			animShadow.animation = "jump_loop"
		"jump_forwards":
			animController.animation = "jump_forwards_loop"
			animShadow.animation = "jump_forwards_loop"
		"jump_backwards":
			animController.animation = "jump_backwards_loop"
			animShadow.animation = "jump_backwards_loop"
		"landing":
			$CSM/Jump.emit_signal("landing_finished")
		"stand_to_crouch":
			animController.animation = "crouching"
			animShadow.animation = "crouching"
		"crouch_turning":
			animController.animation = "crouching"
			animShadow.animation = "crouching"
		"crouch_to_stand":
			$CSM/Crouch.emit_signal("standing")
		"stagger":
			$CSM/Stagger.emit_signal("recover")
