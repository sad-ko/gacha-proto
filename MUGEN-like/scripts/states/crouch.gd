##################################crouch.gd#####################################
""" Estado agachado, no permite movimiento solo rotar de lado y al soltar su
	tecla se cambia de estado """
################################################################################
extends State

# warning-ignore:unused_signal
signal standing

var turned : bool # Evita un bug al querer voltearse al mismo lado en el que mira
var crouching : bool # Evita quedarse atascado en el estado crouch


func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("standing", self, "transition_afterStanding")


func enter(_msg := {}) -> void:
	turned = false
	crouching = true
	character.velocity = Vector2.ZERO
	character.animController.animation = "stand_to_crouch"


func physics_update(_delta) -> void:
	if crouching:
		if Input.is_action_just_released("crouch"):
			character.animController.animation = "crouch_to_stand"
			crouching = false
		elif Input.is_action_pressed("walk_left") and not turned:
			character.animController.flip_h = true
			character.animShadow.flip_h = true
			character.animController.animation = "crouch_turning"
			turned = true
		elif Input.is_action_pressed("walk_right") and turned:
			character.animController.flip_h = false
			character.animShadow.flip_h = false
			character.animController.animation = "crouch_turning"
			turned = false


### Solo se ejecuta al terminar la animacion de pararse 			###
##  Como no se permite movimiento hasta terminar la animacion		 ##
#	la animacion se reproduce a una velocidad mas alta que el resto   #
func transition_afterStanding():
	state_machine.transition_to("Idle")


func exit() -> void:
	# Restaura el sentido de las animaciones antes de pasar de estado #
	character.animController.flip_h = false
	character.animShadow.flip_h = false



################################################################################
