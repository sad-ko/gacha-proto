extends Node2D

var stateName : String = ""
var currentState : String = ""

onready var csmNode = $Character/CSM
onready var zoomIn = $Character/Camera2D
onready var zoomOut = $ZoomOut
onready var stateLabel = $CanvasLayer/Control/Label
onready var guiControl = $CanvasLayer/Control

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

func _on_CheckBox_toggled(_button_pressed: bool) -> void:
	if zoomIn.current == true:
		zoomOut.current = true
	else:
		zoomIn.current = true
