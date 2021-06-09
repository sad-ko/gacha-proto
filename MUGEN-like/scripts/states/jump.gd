# jump.gd
extends State

var double_jump : bool = true
var direction : float = 0.0
# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		character.animController.animation = "jump"
		character.velocity.y = -character.jump_power
	if msg.has("do_jump_forward"):
		character.animController.animation = "jump_forwards"
		character.velocity.y = -character.jump_power
		character.velocity.x += (1 * character.speed)/2
	if msg.has("do_jump_backward"):
		character.animController.animation = "jump_backwards"
		character.velocity.y = -character.jump_power
		character.velocity.x -= (1 * character.speed)/2


func physics_update(delta: float) -> void:
	character.motion(delta)
	
	#Dobule Jump
#	if double_jump and not character.is_on_floor():
#		jumping_direction()
	
	# Landing.
	if character.is_on_floor():
		character.animController.animation = "landing"
		if character.velocity.x == 0:
			yield(character.animController, "animation_finished")
		if is_equal_approx(character.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")


func jumping_direction() -> void:
	if Input.is_action_pressed("walk_right") and Input.is_action_pressed("jump"):
		character.animController.animation = "jump_forwards"
		character.velocity.y = -character.jump_power / 2
		#character.velocity.x += 1 * character.speed
	elif Input.is_action_pressed("walk_left") and Input.is_action_pressed("jump"):
		character.animController.animation = "jump_backwards"
		character.velocity.y = -character.jump_power / 2
		#character.velocity.x -= 1 * character.speed
	elif Input.is_action_just_pressed("jump"):
		character.animController.animation = "jump"
		character.velocity.y = -character.jump_power
		#double_jump = false
