##################################walk.gd#######################################
""" Estado de movimiento horizontal, solo se activa si el personaje es
	movido por el usuario """
################################################################################
extends State


func physics_update(delta: float) -> void:
	# Explicado en idle.gd #
	if not character.is_on_floor():
		state_machine.transition_to("Jump")
		return
	
	# Recibe el valor actual del eje X #
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


### Depende el valor del eje X, para que lado mira el personaje ###
func walking_direction(facing):
	if facing > 0:
		character.animController.animation = "walk_right"
	elif facing < 0:
		character.animController.animation = "walk_left"



################################################################################
