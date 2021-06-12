extends State

signal recover

func enter(_msg := {}) -> void:
	character.animController.animation = "stagger"
	if not is_connected("recover", self, "transition_afterRecover"):
		# warning-ignore:return_value_discarded
		connect("recover", self, "transition_afterRecover")

func physics_update(delta: float) -> void:
	character.motion(delta)

func transition_afterRecover():
	state_machine.transition_to("Idle")
