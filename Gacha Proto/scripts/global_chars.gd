extends Node

var roll = -1

#Loads characters
var phosu = preload("res://chars/phosu.tscn").instance()
var jorge = preload("res://chars/jorge.tscn").instance()
var madoka = preload("res://chars/madoka.tscn").instance()
var dio = preload("res://chars/dio.tscn").instance()
var kobeni = preload("res://chars/kobeni.tscn").instance()
var makima = preload("res://chars/makima.tscn").instance()
var sugimoto = preload("res://chars/sugimoto.tscn").instance()
#Chars array
var char_list = Array()
var char_id = Array()

func _ready():
	#Appends to Array
	char_list.append(phosu.char_name)
	char_id.append(phosu)
	char_list.append(jorge.char_name)
	char_id.append(jorge)
	char_list.append(madoka.char_name)
	char_id.append(madoka)
	char_list.append(dio.char_name)
	char_id.append(dio)
	char_list.append(kobeni.char_name)
	char_id.append(kobeni)
	char_list.append(makima.char_name)
	char_id.append(makima)
	char_list.append(sugimoto.char_name)
	char_id.append(sugimoto)

func add_png(pull):
	if char_id[pull].get_parent():
		char_id[pull].get_parent().remove_child(char_id[pull])
	get_tree().current_scene.add_child(char_id[pull])
	#Moves child in the tree index to avoid overlaying on the text
	get_tree().current_scene.move_child(char_id[pull], 3)

func effect(show_effect):
	char_id[roll].png.modulate.a = show_effect
	#char_id[roll].overlay.modulate.a = 0.0 

func slide():
	char_id[roll].png.rect_position.x += 10
	#char_id[pull].overlay.rect_position.x = pos 

func remove_effect(pull):
	char_id[pull].png.modulate.a = 0.0
	char_id[pull].overlay.modulate.a = 0.0 
