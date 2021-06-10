extends State

# warning-ignore:unused_signal
signal standing

var turned : bool
var crouching : bool

func enter(_msg := {}) -> void:
	if not is_connected("standing", self, "transition_afterStanding"):
		# warning-ignore:return_value_discarded
		connect("standing", self, "transition_afterStanding")
	
	turned = false
	crouching = true
	character.velocity = Vector2.ZERO
	character.animController.animation = "stand_to_crouch"

func physics_update(_delta) -> void:
	# Extra if needed to avoid getting stuck on the crouch state
	if crouching:
		if Input.is_action_just_released("crouch"):
			character.animController.animation = "crouch_to_stand"
			crouching = false
		elif Input.is_action_pressed("walk_left") and not turned:
			character.animController.flip_h = true
			character.animController.animation = "crouch_turning"
			turned = true
		elif Input.is_action_pressed("walk_right") and turned:
			character.animController.flip_h = false
			character.animController.animation = "crouch_turning"
			turned = false

func transition_afterStanding():
	state_machine.transition_to("Idle")

func exit() -> void:
	character.animController.flip_h = false
