############################### 	arena.gd 	################################
extends Node2D

var undoSkill : Node
var undoArray : Array
var skillArray : Array
var skillPos : int = 380


func _ready() -> void:
	### Reset combat values ###
	Combat.victory = false
	Combat.selected_skills = 0
	Combat.set_enemies_grid()


func _process(_delta: float) -> void:
	if Combat.victory:
		$Overlay.show()
		$VictoryLabel.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimationPlayer.play("VictoryScreen")
		set_process(false)
	
	if Combat.turn_ends:
		reenable_ALL_skills()
		Combat.turn_ends = false


func _input(event: InputEvent) -> void:
	if Combat.victory and event is InputEventScreenTouch:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func activate_skill(button):
	undoSkill = Button.new()
	undoSkill.add_to_group("Removable")
	undoSkill.rect_size = Vector2(64, 64)
	skillPos += 120
	undoSkill.rect_position = Vector2(skillPos, 50)
	# warning-ignore:return_value_discarded
	undoSkill.connect("button_up", self, "undo_skill", [undoSkill])
	add_child(undoSkill)
	undoArray.append(undoSkill)
	skillArray.append(button)
	button.disabled = true
	Combat.selected_skills += 1


func undo_skill(node):
	var temp = undoArray.back()
	if node == temp:
		Combat.selected_skills -= 1
		undoArray.remove(undoArray.size() - 1)
		reenable_skills(skillArray.back())
		skillArray.remove(skillArray.size() - 1)
		skillPos -= 120
		temp.queue_free()


### EXTREMELY TEMPORAL ###
func reenable_skills(button):
	button.disabled = false

func reenable_ALL_skills():
	skillPos = 380
	var array = get_tree().get_nodes_in_group("Removable")
	for i in range(3):
		var temp = array[i]
		temp.queue_free()
	
	### THIS IS HORRIBLE ###
	$Button.disabled = false
	$Button2.disabled = false
	$Button3.disabled = false
	$Button4.disabled = false
	$Button5.disabled = false

func _on_Button_button_up() -> void:
	activate_skill($Button)

func _on_Button2_button_up() -> void:
	activate_skill($Button2)

func _on_Button3_button_up() -> void:
	activate_skill($Button3)

func _on_Button4_button_up() -> void:
	activate_skill($Button4)

func _on_Button5_button_up() -> void:
	activate_skill($Button5)


############################### 	END 	####################################
