#####################################states.gd##################################
""" Clase base para todos los estados, todo nodo extendido de esta clase
	podra utilizar sus variables y funciones nativamente """
################################################################################
extends Node
class_name State

### Variable que deriva a la maquina de estados ###
##  la propia maquina se asignara a si mismo	 ##
var state_machine = null

### Referencia al nodo base del personaje 		###
##  solo definimos su clase, se asigna despues	 ##
var character : character_base

func _ready() -> void:
	# Espera que el nodo principal termine de cargar #
	yield(owner, "ready")
	
	# Asigna el root node de la escena como el personaje #
	character = owner as character_base


### Funciones del engine derivadas de la maquina de estados ###
## handle_input() == _unhandled_input() ##
func handle_input(_event: InputEvent) -> void:
	pass
	
## update() == _process() ##
func update(_delta: float) -> void:
	pass

## physics_update() == _physics_process() ##
func physics_update(_delta: float) -> void:
	pass


### Funcion que se ejecuta solo cuando se inicializa el estado 		 ###
##  es llamado por la maquina de estados, permite mensajes opcionales ##
func enter(_msg := {}) -> void:
	pass


### Funcion que se ejecuta solo cuando se termina el estado			###
##  es llamado por la maquina de estados antes de pasar de estado	 ##
func exit() -> void:
	pass


### Controla la direccion del salto, como es llamado en varios estados ###
##  se lo armo como primitva para evitar copiar el mismo codigo			##
func jumping_direction() -> int:
	var jumped : int = 1
	
	if Input.is_action_pressed("walk_right") and Input.is_action_just_pressed("jump"):
										  # Mensaje opcional que recibe enter()
		state_machine.transition_to("Jump", {do_jump_forward = true})
	elif Input.is_action_pressed("walk_left") and Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump_backward = true})
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	else: jumped = 0
	
	return jumped



################################################################################
