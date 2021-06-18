#####################################scene.gd###################################
""" Script de la escena de pruebas, nada relevante, probablemente casi todo
	sea reemplazado con el tiempo """
################################################################################
extends Node2D

var stateName : String = ""
var currentState : String = ""

onready var csmNode = $Character/CSM
onready var zoomIn = $Character/ZoomIn
onready var zoomOut = $ZoomOut
onready var stateLabel = $CanvasLayer/Control/Label
onready var guiControl = $CanvasLayer/Control
onready var chara = $Character


func _ready() -> void:
	stateName = csmNode.state.name
	currentState = stateName
	stateLabel.text = "State: %s" % stateName
	
	zoomOut.current = true


func _process(_delta: float) -> void:
	if stateName != csmNode.state.name:
		stateName = csmNode.state.name
	
	if currentState != stateName:
		stateLabel.text = "State: %s" % stateName
		currentState = stateName


func _on_ZoomIn_toggled(button_pressed: bool) -> void:
	if button_pressed:
		zoomIn.current = true
	else:
		zoomOut.current = true

func _on_Lights_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$Light2D.enabled = true
	else: $Light2D.enabled = false

func _on_Water_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$Water.show()
	else:
		$Water.hide()

func _on_Shadows_toggled(button_pressed: bool) -> void:
	if button_pressed:
		chara.animShadow.show()
	else: chara.animShadow.hide()



################################################################################
