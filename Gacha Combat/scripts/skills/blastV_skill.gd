extends Button

# warning-ignore:unused_signal
signal skill_effect


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("skill_effect", self, "blastV_effect")

func blastV_effect():
	print("BlastV!")
	var size = Combat.current_target.get_parent().allies_v + 1
	for i in size:
		Combat.enemiesArray[i].enemy_hp -= 5
