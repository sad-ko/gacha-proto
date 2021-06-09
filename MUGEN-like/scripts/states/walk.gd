# walk.gd
extends State

func physics_update(delta: float) -> void:
	if not character.is_on_floor():
		state_machine.transition_to("Jump")
		return

	var input_direction_x : float = character.char_input(delta)
	walking_direction(input_direction_x)
	
	if jumping_direction():
		pass
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")

func walking_direction(facing):
	if facing > 0:
		character.animController.animation = "walk_right"
	elif facing < 0:
		character.animController.animation = "walk_left"

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
