############################### 	heroe.gd 	################################
extends Sprite

var player_hp : int = 10
var ply_previous_hp : int = 0

onready var anim = $AnimationPlayer
onready var heroes_hp_indicator = $HeroesHP


func _ready() -> void:
	Combat.prev_position = self.position ###TEMPORAL###
	Combat.current_turn = self ###TEMPORAL###
	ply_previous_hp = player_hp


func _process(_delta: float) -> void:
	if ply_previous_hp != player_hp:
		heroes_hp_indicator.text = " %d" % player_hp + "/%d" % Combat.MAX_HEALT
		ply_previous_hp = player_hp


func _on_PlayerArea2D_area_entered(area: Area2D) -> void:
	### Avoids collisioning with other enemies or heroes ###
	if area == Combat.current_target:
		### Stops animation right in front of the target ###
		Combat.tween.stop(Combat.current_turn)
	
		$SFX.show()
		anim.play("SFX")
		yield(get_tree().create_timer(0.9), "timeout")
		$SFX.hide()
	
		Combat.current_target.get_parent().enemy_hp -= 5
	
		yield(get_tree().create_timer(0.5), "timeout")
		Combat.tween.resume(Combat.current_turn)
		Combat.reset_position()


############################### 	END 	####################################
