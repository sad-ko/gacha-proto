# idle.gd
extends State

func enter(_msg := {}) -> void:
	character.velocity = Vector2.ZERO
	character.animController.animation = "idle"

func physics_update(_delta) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not owner.is_on_floor():
		state_machine.transition_to("Jump")
		return
	
	if jumping_direction():
		pass
	elif Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		state_machine.transition_to("Walk")

func jumping_direction() -> int:
	var jumped : int = 1
	
	if Input.is_action_pressed("walk_right") and Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump_forward = true})
	elif Input.is_action_pressed("walk_left") and Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump_backward = true})
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	else: jumped = 0
	
	return jumped
