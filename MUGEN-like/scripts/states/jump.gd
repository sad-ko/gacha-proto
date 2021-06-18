##################################jump.gd#######################################
""" The biggest fucker so far, una vez en el aire no se permite movimiento
	del jugador, doble salto, y puede transicionar fluidamente a otros estados
	una vez esta en el suelo a excepcion de los ataques en el aire """
################################################################################
extends State

# warning-ignore:unused_signal
signal landing_finished

var double_jump : bool


func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("landing_finished", self, "transition_afterLanding")


### If we get a message asking us to jump, we jump. ###
func enter(msg := {}) -> void:
	double_jump = true
	character.velocity.x = 0 # Evita movimientos indesados
	character.animController.frame = 0 # Reseta la actual animacion
	character.animShadow.frame = 0
	
	# Elige que hacer en base al mensaje recibido
	if msg.has("do_jump"):
		character.animController.animation = "jump"
		character.velocity.y = -character.jump_power
	elif msg.has("do_jump_forward"):
		character.animController.animation = "jump_forwards"
		character.velocity.y = -character.jump_power
		character.velocity.x += (character.speed * 2)
	elif msg.has("do_jump_backward"):
		character.animController.animation = "jump_backwards"
		character.velocity.y = -character.jump_power
		character.velocity.x -= (character.speed * 2)


func physics_update(delta: float) -> void:
	# Permite movimientos fisicos como la gravedad, pero no del jugador
	character.motion(delta)
	
	# Dobule Jump
	if double_jump and not character.is_on_floor():
		if jumping_direction():
			double_jump = false
	
	# Landing.
	if character.is_on_floor():
		character.splash()
		character.animController.animation = "landing"
		character.velocity.x = 0 # Evita accidentales deslices
		
		if Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
			state_machine.transition_to("Walk")
		elif jumping_direction():
			pass # Permite volver a saltar instantaneamte al tocar el suelo
		elif Input.is_action_pressed("crouch"):
			state_machine.transition_to("Crouch")
	
	if Input.is_action_just_pressed("stagger"):
		state_machine.transition_to("Stagger")


### Esta funcion solo se ejecuta cuando se emite la señal "landing_finished" ###
##  y solo se emite cuando la animacion "landing" termina, solo termina si    ##
#	no hubo input del jugador, en ese caso la animacion se cancela			   #
func transition_afterLanding():
	state_machine.transition_to("Idle")



################################################################################
