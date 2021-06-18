################################character_base.gd###############################
""" El padre absoluto de los estados, cualquier funcion o variable que se
	desarrolle aqui se podra utilizar en cualquier estado """
################################################################################
extends KinematicBody2D

### Por ahora es una nueva clase, pero realmente no se usa en ningun lado ###
class_name character_base

export (int) var speed = 200
export (int) var gravity = 3200
export (int) var jump_power = 1000

var velocity : Vector2

var waterSplash : PackedScene = preload("res://resources/water_splash.tscn")
onready var water = get_parent().get_node("Water")
onready var waterAnim = get_parent().get_node("WaterAnim")

onready var animController = $AnimatedSprite
onready var animShadow = $ShadowLayer/Shadow
onready var canvas = $ShadowLayer


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# Solo cuando las sombras esten activadas #
	if animShadow.visible:
		animShadow.animation = animController.animation
		canvas.offset.x = self.position.x
		
		if velocity.y < 0:
			canvas.offset.y += 1.5
		elif not is_on_floor() and velocity.y > 0: 
			canvas.offset.y -= 1.5
		else: canvas.offset.y = self.position.y


### Mueve el personaje por el eje x, devuelve el valor del eje x ###
func char_input(delta) -> float:
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += 1 * speed
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1 * speed
	
	velocity.y += gravity * delta
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP, true)
	
	return velocity.x

### Permite mover al personaje solo atravez de fisicas	###
##  no acepta movimiento ingresado por el usuario		 ##
func motion(delta) -> void:
	velocity.y += gravity * delta
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP, true)


### Genera las particulas de agua ###
func splash() -> void:
	var array = get_tree().get_nodes_in_group("Splash")
	# Solo permite un maximo de 3 particulas a la vez #
	if array.size() < 3 and water.visible:
		waterAnim.play("ripple")
		var splash_inst = waterSplash.instance()
		# Instancia la particula en los pies del personaje #
		splash_inst.position = Vector2(self.position.x, self.position.y + 55)
		get_tree().current_scene.add_child(splash_inst)
		splash_inst.emitting = true

### Con Esc podes cerrar el juego ###
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


### Controlamos que hacer cuando una animacion especifica termina	###
##  Sea cambiarla a otra o emitir una señal para pasar de estado	 ##
func _on_AnimatedSprite_animation_finished() -> void:
	match (animController.animation):
		"jump":
			animController.animation = "jump_loop"
		"jump_forwards":
			animController.animation = "jump_forwards_loop"
		"jump_backwards":
			animController.animation = "jump_backwards_loop"
		"landing":
			$CSM/Jump.emit_signal("landing_finished")
		"stand_to_crouch":
			animController.animation = "crouching"
		"crouch_turning":
			animController.animation = "crouching"
		"crouch_to_stand":
			$CSM/Crouch.emit_signal("standing")
		"stagger":
			$CSM/Stagger.emit_signal("recover")



################################################################################
