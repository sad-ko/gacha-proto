############################### 	arena.gd 	################################
extends Node2D

var undoSkill : Node
var undoArray : Array
var skillArray : Array ### Stores selected skills ###
var skillPos : int = 380
var loadSkills : Array ### Load all skills on an array of size 4 ###
var setSkills : Array ### Put 5 skills of the previous array randomized ###

onready var skillContainer = $SkillContainer

func _ready() -> void:
	### Reset combat values ###
	Combat.currentSkills.clear()
	Combat.victory = false
	Combat.selected_skills = 0
	Combat.set_enemies_grid()
	load_skills()
	show_skill()


func _process(_delta: float) -> void:
	if Combat.victory:
		$Overlay.show()
		$VictoryLabel.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimationPlayer.play("VictoryScreen")
		set_process(false)
	
	if Combat.turn_ends:
		reenable_ALL_skills()
		show_skill()
		Combat.turn_ends = false

func _input(event: InputEvent) -> void:
	if Combat.victory and event is InputEventScreenTouch:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func activate_skill(button, skill_icon):
	Combat.currentSkills.append(button)
	undoSkill = Button.new()
	undoSkill.add_to_group("Removable")
	undoSkill.flat = true
	var icon_name = "%s" % skill_icon.get_path()
	var icon_70 = icon_name.replace(".png", "_70.png")
	undoSkill.icon = load(icon_70)
	undoSkill.set("custom_styles/focus",StyleBoxEmpty.new())
	#undoSkill.rect_size = Vector2(64, 64)
	skillPos += 120
	undoSkill.rect_position = Vector2(skillPos, 50)
	# warning-ignore:return_value_discarded
	undoSkill.connect("button_up", self, "undo_skill", [undoSkill])
	add_child(undoSkill)
	undoArray.append(undoSkill)
	skillArray.append(button)
	button.disabled = true
	Combat.selected_skills += 1

func reenable_skills(button):
	button.disabled = false

func undo_skill(node):
	var temp = undoArray.back()
	if node == temp:
		Combat.selected_skills -= 1
		undoArray.remove(undoArray.size() - 1)
		reenable_skills(skillArray.back())
		skillArray.remove(skillArray.size() - 1)
		skillPos -= 120
		temp.queue_free()


func load_skills():
	var accel = load("res://scenes/skills/accel_skill.tscn")
	loadSkills.append(accel)
	var blastH = load("res://scenes/skills/blastH_skill.tscn")
	loadSkills.append(blastH)
	var blastV = load("res://scenes/skills/blastV_skill.tscn")
	loadSkills.append(blastV)
	var charge = load("res://scenes/skills/charge_skill.tscn")
	loadSkills.append(charge)

func set_skills():
	randomize()
	
	for randSkill in range(5):
		randSkill = randi() % 4
		setSkills.append(loadSkills[randSkill])
	
	setSkills.shuffle() ### Just for fun ###

func show_skill():
	set_skills()
	
	for i in range(5):
		var skillInst = setSkills[i].instance()
		skillInst.add_to_group("Removable")
		skillContainer.add_child(skillInst)
		skillInst.connect("button_up", self, "activate_skill", [skillInst, skillInst.icon])


func reenable_ALL_skills():
	skillPos = 380
	var array = get_tree().get_nodes_in_group("Removable")
	for i in range(8):
		var temp = array[i]
		temp.queue_free()
	
	for i in range(3):
		reenable_skills(skillArray[i])

	skillArray.clear()
	undoArray.clear()
	setSkills.clear()
	
	var size = Combat.currentSkills.size()
	if size:
		for i in size:
			Combat.currentSkills.remove(i)

############################### 	END 	####################################
