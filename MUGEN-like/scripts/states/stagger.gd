##################################stagger.gd#######################################
""" Estado de shock al recibir daño, evita por completo el movimiento ingresado
	por el jugador		TODO - Agregar animaciones, ajustar tiempo y demas """
################################################################################
extends State

# warning-ignore:unused_signal
signal recover

func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("recover", self, "transition_afterRecover")

func enter(_msg := {}) -> void:
	character.animController.animation = "stagger"

func physics_update(delta: float) -> void:
	character.motion(delta)

func transition_afterRecover():
	state_machine.transition_to("Idle")



################################################################################
