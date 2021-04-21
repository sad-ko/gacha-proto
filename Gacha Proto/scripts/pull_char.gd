extends Label

const NUM_CHARS = 6

var pull = -1
var num_pull = 0
var gems = 300
var pity = 0

var sort = NUM_CHARS
var laps = 0

var show_effect = 0.0
#var char_list_bak = ["Dio", "Sugimoto", "Madoka", "Kobeni", "Makima", "Phosu~", "Jorge! (SSR)"]

onready var numPull_text = $NumPull
onready var gems_text = $Gems
onready var GlobalChars = get_node("/root/PullMenu")

func _ready():
	randomize()
	text = "\tPress pull to roll" 
	set_physics_process(false)

func _process(_delta):
	gems_text.text = "Gems: " + "%d" % gems
	if laps >= 4:
		set_physics_process(false)
		text = "\nChar: " + GlobalChars.char_list[pull]
		laps = 0

	if pull >= 0 and show_effect < 0.9 and laps == 0:
		show_effect += 0.05
		GlobalChars._effect(show_effect, pull)

func _physics_process(_delta):
	text = "\nChar: " + GlobalChars.char_list[sort]
	sort -= 1
	if sort < 0:
		sort = NUM_CHARS
		laps += 1

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _pity():
	print("Star: " + "%d" % GlobalChars.char_id[pull].stars)
	print("Name: " + GlobalChars.char_list[pull])
	if GlobalChars.char_id[pull].stars == 4:
		_chance(50)
	if GlobalChars.char_id[pull].stars == 5 and pity < 10:
		_chance(5)
	if pity == 10:
		pity = 0
		var chance = randi() % 100 + 1
		if chance > 50:
			pull = 5
		else: pull = 1

func _chance(probability):
	#If chance it's bigger than probability pull again
	var chance = randi() % 100 + 1
	print("Chance: " + "%d" % chance)
	if chance > probability:
		pull = randi() % NUM_CHARS + 1
		_pity()

func _effect():
	laps = 1
	if pull >= 0:
		show_effect = 0.0
		GlobalChars._remove_effect(pull)
	set_physics_process(true)
	
func _on_Button_pressed():
	numPull_text.visible_characters = -1
	if gems > 0:
		num_pull += 1
		pity += 1
		_effect()
		pull = randi() % NUM_CHARS + 1
		_pity()
		GlobalChars._add_png(pull)
		gems -= 10
		numPull_text.text = "Num pull: " + "%d" % num_pull
	else:
		numPull_text.margin_left = 19
		numPull_text.text = "Not enough gems"

func _on_Back_pressed():
	var _err = get_tree().change_scene("res://scenes/menu.tscn")
