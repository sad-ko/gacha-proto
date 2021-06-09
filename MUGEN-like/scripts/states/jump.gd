# jump.gd
extends State

var direction : float = 0.0
var double_jump : bool = true

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	character.velocity.x = 0
	character.animController.frame = 0
	
	if msg.has("do_jump"):
		character.animController.animation = "jump"
		character.velocity.y = -character.jump_power
	if msg.has("do_jump_forward"):
		character.animController.animation = "jump_forwards"
		character.velocity.y = -character.jump_power
		character.velocity.x += (1 * character.speed) * 2
	if msg.has("do_jump_backward"):
		character.animController.animation = "jump_backwards"
		character.velocity.y = -character.jump_power
		character.velocity.x -= (1 * character.speed) * 2
	

func physics_update(delta: float) -> void:
	character.motion(delta)
	
	#Dobule Jump
	if double_jump and not character.is_on_floor():
		doubleJump()
		#double_jump = false
	
	# Landing.
	if character.is_on_floor():
		character.animController.animation = "landing"
		character.velocity.x = 0
		
		if Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
			state_machine.transition_to("Walk")
		else:
			yield(character.animController, "animation_finished")
			state_machine.transition_to("Idle")


func doubleJump() -> int:
	var jumped : int = 1
	
	if Input.is_action_pressed("walk_right") and Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump_forward = true})
	elif Input.is_action_pressed("walk_left") and Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump_backward = true})
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	else: jumped = 0
	
	return jumped
