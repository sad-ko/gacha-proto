extends Node2D

var stateName : String = ""
var currentState : String = ""

onready var stateLabel = $CanvasLayer/Control/Label
onready var guiControl = $CanvasLayer/Control

func _ready() -> void:
	stateName = $Character/CSM.state.name
	currentState = stateName
	stateLabel.text = "State: %s" % stateName
	
	$ZoomOut.current = true

func _process(_delta: float) -> void:
	if stateName != $Character/CSM.state.name:
		stateName = $Character/CSM.state.name
	
	if currentState != stateName:
		stateLabel.text = "State: %s" % stateName
		currentState = stateName

func _on_CheckBox_toggled(_button_pressed: bool) -> void:
	if $Character/Camera2D.current == true:
		$ZoomOut.current = true
	else:
		$Character/Camera2D.current = true
