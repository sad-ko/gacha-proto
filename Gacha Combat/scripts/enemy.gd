############################### 	enemy.gd 	################################
extends Sprite

var enemy_hp : int = 10
var enm_previous_hp : int = 0

onready var area = $Area2D
onready var enemies_hp_indicator = $EnemyHP


func _ready() -> void:
	enm_previous_hp = enemy_hp


func _process(_delta: float) -> void:
	if enm_previous_hp != enemy_hp:
		enemies_hp_indicator.text = " %d" % enemy_hp + "/%d" % Combat.MAX_HEALT
		enm_previous_hp = enemy_hp
	if enemy_hp <= 0:
		dies()


func dies():
	queue_free()
	### Re-orders the enemies array ###
	Combat.emit_signal("enemyDown")


############################### 	END 	####################################
