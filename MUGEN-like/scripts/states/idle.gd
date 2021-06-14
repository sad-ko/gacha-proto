# idle.gd
extends State

func enter(_msg := {}) -> void:
	character.velocity = Vector2.ZERO
	character.animController.animation = "idle"
	character.animShadow.animation = "idle"

func physics_update(_delta) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not owner.is_on_floor():
		state_machine.transition_to("Jump")
		return
		
	if Input.is_action_just_pressed("stagger"):
		state_machine.transition_to("Stagger")
	elif jumping_direction():
		pass
	elif Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		state_machine.transition_to("Walk")
	elif Input.is_action_pressed("crouch"):
		state_machine.transition_to("Crouch")
