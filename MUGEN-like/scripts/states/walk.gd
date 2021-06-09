# walk.gd
extends State

func physics_update(delta: float) -> void:
	if not character.is_on_floor():
		state_machine.transition_to("Jump")
		return

	var input_direction_x : float = character.char_input(delta)
	walking_direction(input_direction_x)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
	#elif input_direction_x < 0.02 or input_direction_x > -0.02:
		state_machine.transition_to("Idle")

func walking_direction(facing):
	if facing > 0:
		character.animController.animation = "walk_right"
	elif facing < 0:
		character.animController.animation = "walk_left"
