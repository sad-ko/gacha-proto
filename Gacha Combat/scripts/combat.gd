############################### 	combat.gd 	################################
extends Node2D

# warning-ignore:unused_signal
signal attack
signal enemyDown

const MAX_HEALT : int = 10

var prev_position : Vector2
var current_target : Node = null
var current_turn : Node = null ### Works to save animation code ###
var turn_ends : bool = false
var selected_skills : int = 0
var victory : bool = false
var enemiesArray : Array
var currentSkills : Array
var tween : Node
var timer : Node


func _ready() -> void:
	### Creates a tween, useful for animating on the moment ###
	tween = Tween.new()
	add_child(tween)
	### Creates a timer ###
	timer = Timer.new()
	timer.wait_time = 2.1
	timer.one_shot = true
	add_child(timer)
	
# warning-ignore:return_value_discarded
	### Check combat status after finishing the attack animation ###
	timer.connect("timeout", self, "combat_status")
# warning-ignore:return_value_discarded
	### Once the tween animations are done checks if the player won ###
	tween.connect("tween_all_completed", self, "victory_screen")
# warning-ignore:return_value_discarded
	### Self-explanatory ###
	connect("attack", self, "attack_animation")
# warning-ignore:return_value_discarded
	### Set enemies order ###
	connect("enemyDown", self, "set_enemies_grid")


func _process(_delta: float) -> void:
	### If the 3 skill had been selected starts attacking ###
	if Combat.selected_skills == 3:
		Combat.emit_signal("attack")
		set_process(false)


func set_enemies_grid():
	### Waits a second for enemies to load ###
	yield(get_tree().create_timer(0.3), "timeout")
	enemiesArray = get_tree().get_nodes_in_group("Enemy")
	if enemiesArray:
		### Always selects the first node Area2D ###
		current_target = enemiesArray[0].area
	else:
		### If they are not more enemies, there is nothing to attack ###
		current_target = null


### Animates attack from starting position to target position ###
func attack_animation():
	tween.interpolate_property(current_turn, "position", null,
		current_target.global_position, 2, tween.TRANS_SINE, tween.EASE_IN)
	tween.start()


### Reset attacker positon after performing their attack ###
func reset_position() -> void:
	#if current_turn.position != prev_position:
	tween.interpolate_property(current_turn, "position", null, prev_position,
		2, tween.TRANS_SINE, tween.EASE_IN)
	### Once the animations ends checks the combat status ###
	timer.start()


### Checks if the turn should end or keep going ###
func combat_status() -> void:
	selected_skills -= 1
	if selected_skills <= 0 || not current_target:
		turn_ends = true
		set_process(true)
	elif current_target:
		emit_signal("attack")


### Seems redundant, but it's the best way to exectue the victory screen after
### all the animatons had been performed
func victory_screen():
	if not current_target:
		victory = true


############################### 	END 	####################################
