extends KinematicBody2D
class_name character_base

export (int) var speed = 200
export (int) var jump_speed = -1600
export (int) var gravity = 2800

var velocity = Vector2.ZERO
var is_not_jumping : bool = true
var is_not_falling : bool = true
var mock : bool = false
var intro : bool = false
var previous_target_pos : int = 0

onready var anim = $AnimatedSprite
onready var target = $RayCast2D

func _ready() -> void:
	#anim.animation = "intro"
	anim.play()

func _physics_process(delta: float) -> void:
	if not intro:
		char_input()
		movement_animation()
		jumping_animation()
	else: velocity.x = 0
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if not target.is_colliding():
		if previous_target_pos > 0:
			target.cast_to *= -1
			target.position.x *= -1
		elif previous_target_pos < 0:
			target.cast_to *= -1
			target.position.x *= -1
	
	if Input.is_action_just_pressed("jump") and not intro:
		if is_on_floor():
			velocity.y = jump_speed

func char_input():
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += speed
	if Input.is_action_pressed("walk_left"):
		velocity.x -= speed

func movement_animation():
	if is_not_jumping and not target.is_colliding():
		if velocity.x > 0.5:
			anim.animation = "walk_right"
		elif velocity.x < -0.5:
			anim.animation = "walk_left"
		elif not mock: anim.animation = "idle"
	elif is_not_jumping and target.is_colliding():
		var target_pos : int = target.get_collision_point().x - self.global_position.x
		previous_target_pos = target_pos
		if target_pos > 0.5 and velocity.x > 0.5:
			anim.play("walk_right", false)
		elif target_pos > 0.5 and velocity.x < -0.5:
			anim.play("walk_right", true)
		elif target_pos < -0.5 and velocity.x < -0.5:
			anim.play("walk_left", false)
		elif target_pos < -0.5 and velocity.x > 0.5:
			anim.play("walk_left", true)
		elif not mock: anim.animation = "idle"

func jumping_animation():
	if is_not_jumping and not is_on_floor():
		if velocity.y < -1:
			flip_jump()
			anim.animation = "jump"
			is_not_jumping = false
	
	if is_not_falling and not is_on_floor() and not intro:
		if velocity.y > 0:
			flip_jump()
			anim.animation = "pre_fall"
			is_not_falling = false
	
	if is_on_floor():
		anim.flip_h = false
		is_not_jumping = true
		is_not_falling = true

func flip_jump():
	if velocity.x >= 1:
		anim.flip_h = false
	elif velocity.x <= -1:
		anim.flip_h = true

func _on_AnimatedSprite_animation_finished() -> void:
	if anim.animation == "pre_fall":
		anim.animation = "falling"
	
	if anim.animation == "mock" or anim.animation == "intro":
		mock = false
		intro = false
		anim.animation = "idle"
