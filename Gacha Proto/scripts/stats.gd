extends Node

var num_pull = 0
var gems = 300
var pity = 0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
