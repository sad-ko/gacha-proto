extends Node

onready var cost_text = $Cost/CostNumber
onready var gems_text = $Gems/GemsNumber
var cost = 10

func _ready() -> void:
	cost_text.text = "%d" % cost
	gems_text.text = "%d" % Stats.gems

func _on_PullMenu_pressed():
	#Changes scenes
	var _err = get_tree().change_scene("res://scenes/pull_video.tscn")


func _on_PullMenu2_pressed() -> void:
	get_tree().quit()
