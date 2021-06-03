############################### 	enemy.gd 	################################
extends Sprite

var enemy_hp : int = 10
var enm_previous_hp : int = 0
var allies_v : int = 0
var first : int = 1

onready var area = $Area2D
onready var enemies_hp_indicator = $EnemyHP
onready var vertical_sensor = $Vertical

func _ready() -> void:
	set_physics_process(false)
	enm_previous_hp = enemy_hp

func _process(_delta: float) -> void:
	if enm_previous_hp != enemy_hp:
		enemies_hp_indicator.text = " %d" % enemy_hp + "/%d" % Combat.MAX_HEALT
		enm_previous_hp = enemy_hp
	if enemy_hp <= 0:
		dies()
	if Combat.current_target == area and first:
		detect_vertical()
		first = 0

func detect_vertical():
	vertical_sensor.enabled = true
	yield(get_tree().create_timer(0.5), "timeout")
	var ally = vertical_sensor.get_collider()
	while ally:
		allies_v += 1
		vertical_sensor.add_exception(ally)
		yield(get_tree().create_timer(0.01), "timeout")
		ally = vertical_sensor.get_collider()
	vertical_sensor.enabled = false

func dies():
	queue_free()
	### Re-orders the enemies array ###
	Combat.emit_signal("enemyDown")


############################### 	END 	####################################
