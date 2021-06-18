##################################idle.gd#######################################
""" Estado idle al que siempre se vuelve cuando se dejo de recibir 
	input del jugador """
################################################################################
extends State


func enter(_msg := {}) -> void:
	character.velocity = Vector2.ZERO
	character.animController.animation = "idle"


func physics_update(_delta) -> void:
	# En caso que el personaje de repente caiga  #
	## se cambia de estado al correspondiente	##
	if not owner.is_on_floor():
		state_machine.transition_to("Jump") # Debe cambiarse a un estado "fall"
		return
	
	# Revisa si debe pasar de estado #
	if Input.is_action_just_pressed("stagger"):
		state_machine.transition_to("Stagger")
	elif jumping_direction():
		pass
	elif Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		state_machine.transition_to("Walk")
	elif Input.is_action_pressed("crouch"):
		state_machine.transition_to("Crouch")



################################################################################
