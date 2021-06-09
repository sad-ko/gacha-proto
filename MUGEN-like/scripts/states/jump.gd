# jump.gd
extends State

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		character.velocity.y = -character.jump_power


func physics_update(delta: float) -> void:
	# Horizontal movement.
	var input_direction_x: float = character.char_input(delta)
	jumping_direction(character.velocity)
	
	# Landing.
	if character.is_on_floor():
		character.animController.animation = "landing"
		yield(character.animController, "animation_finished")
		if is_equal_approx(input_direction_x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")

func jumping_direction(facing):
	if facing.y < 0 and facing.x == 0:
		character.animController.animation = "jump"
	elif facing.y < 0 and facing.x > 0:
		character.animController.animation = "jump_forwards"
	elif facing.y < 0 and facing.x < 0:
		character.animController.animation = "jump_backwards"
