extends KinematicBody2D
class_name character_base

export (int) var speed = 300
export (int) var jump_speed = -1600
export (int) var gravity = 2800

var velocity = Vector2.ZERO
var is_not_jumping : bool = true
var is_not_falling : bool = true
var mock : bool = false
onready var anim = $AnimatedSprite

func _ready() -> void:
	anim.animation = "idle"
	anim.play()

func _physics_process(delta: float) -> void:
	char_input()
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_not_jumping:
		if velocity.x >= 1:
			anim.animation = "walk_right"
		elif velocity.x <= -1:
			anim.animation = "walk_left"
		elif not mock: anim.animation = "idle"
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	
	if is_not_jumping and not is_on_floor():
		if velocity.y < -1:
			flip_jump()
			anim.animation = "jump"
			is_not_jumping = false
	
	if is_not_falling and not is_on_floor():
		if velocity.y > 0:
			flip_jump()
			anim.animation = "pre_fall"
			is_not_falling = false
	
	if is_on_floor():
		anim.flip_h = false
		is_not_jumping = true
		is_not_falling = true
		
	#print(velocity.y)##Remove##

func char_input():
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += speed
	if Input.is_action_pressed("walk_left"):
		velocity.x -= speed

func flip_jump():
	if velocity.x >= 1:
		anim.flip_h = false
	elif velocity.x <= -1:
		anim.flip_h = true

func _on_AnimatedSprite_animation_finished() -> void:
	if anim.animation == "pre_fall":
		anim.animation = "falling"
	if anim.animation == "mock":
		mock = false
		anim.animation = "idle"
