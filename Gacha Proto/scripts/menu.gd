extends Node

func _on_PullMenu_pressed():
	#Changes scenes
	var _err = get_tree().change_scene("res://scenes/pull.tscn")
