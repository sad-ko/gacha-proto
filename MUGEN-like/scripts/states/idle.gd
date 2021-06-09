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
	
	if Input.is_action_just_pressed("jump"):
		# As we'll only have one air state for both jump and fall, we use the `msg` dictionary 
		# to tell the next state that we want to jump.
		state_machine.transition_to("Jump", {do_jump = true})
	elif Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		state_machine.transition_to("Walk")
