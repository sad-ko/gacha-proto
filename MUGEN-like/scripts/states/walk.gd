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
	elif Input.is_action_pressed("crouch"):
		state_machine.transition_to("Crouch")
	elif Input.is_action_just_pressed("stagger"):
		state_machine.transition_to("Stagger")

func walking_direction(facing):
	if facing > 0:
		character.animController.animation = "walk_right"
		character.animShadow.animation = "walk_right"
	elif facing < 0:
		character.animController.animation = "walk_left"
		character.animShadow.animation = "walk_left"
