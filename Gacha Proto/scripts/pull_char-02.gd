extends Label

const NUM_CHARS = 6

#var Pull.roll = -1
var sort = NUM_CHARS
var loops = 1
#var show_effect = 0.0

#onready var num_pull_text = $NumPull
onready var Pull = get_parent().get_node("Pull")

func _ready():
	randomize()
	text = "" 
	set_physics_process(false)
	yield(get_tree().create_timer(0.5), "timeout")	#Waits for arrays to load
	_pull()

func _process(_delta):
	if loops >= 4:	#It loops 3 times since loops starts at 1
		set_physics_process(false)
		text = "" + Pull.char_list[Pull.roll]
		loops = 0

	#if Pull.roll >= 0 and show_effect < 0.9 and loops == 0:
	#	show_effect += 0.01
	#	Pull.effect(show_effect, Pull.roll)

func _physics_process(_delta):
	#Fast speed sort text animation
	text = "" + Pull.char_list[sort]
	sort -= 1
	if sort < 0:
		sort = NUM_CHARS
		loops += 1

func _pity():
	#print("Star: " + "%d" % Pull.char_id[Pull.roll].stars)
	#print("Name: " + Pull.char_list[Pull.roll])
	if Pull.char_id[Pull.roll].stars == 4:
		_chance(50)
	if Pull.char_id[Pull.roll].stars == 5 and Stats.pity < 10:
		_chance(5)
	if Stats.pity == 10:
		Stats.pity = 0
		#Gives you one of the two 5 stars characters
		var chance = randi() % 100 + 1
		if chance > 50:
			Pull.roll = 5
		else: Pull.roll = 1

func _chance(probability):
	var chance = randi() % 100 + 1
	#print("Chance: " + "%d" % chance)
	#If chance it's bigger than probability Pull.roll again
	if chance > probability:
		Pull.roll = randi() % NUM_CHARS + 1
		_pity() 	#Recursion

func _effect():
	#Sets everything for the effects to work
	loops = 1
	#if Pull.roll >= 0:
		#show_effect = 0.0
		#Pull.remove_effect(Pull.roll)
	set_physics_process(true)

func _pull():
#func _on_Button_pressed():
	#num_pull_text.visible_characters = -1
	if Stats.gems > 0:
		Stats.num_pull += 1
		Stats.pity += 1
		_effect()
		Pull.roll = randi() % NUM_CHARS + 1
		_pity()
		Pull.add_png(Pull.roll)
		Stats.gems -= 10
		#num_pull_text.text = "Num Pull.roll: " + "%d" % Stats.num_pull
	#else:
	#	num_pull_text.margin_left = 19
	#	num_pull_text.text = "Not enough gems"

func _on_Back_pressed():
	var _err = get_tree().change_scene("res://scenes/menu.tscn")
