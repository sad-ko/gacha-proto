extends Node

onready var video = $VideoPlayer
onready var overlay = $ColorRect
onready var jorge = $TextureRect
onready var sfx = $AudioStreamPlayer
onready var name_t = $Label

onready var star1 = $Control/Star
onready var star2 = $Control/Star2
onready var star3 = $Control/Star3
onready var star4 = $Control/Star4
onready var star5 = $Control/Star5

var array = Array()
#var i = 0
#var count = 0

func _ready() -> void:	
	array.append(star1)
	array.append(star2)
	array.append(star3)
	array.append(star4)
	array.append(star5)
	
	for i in 5:
		array[i].hide()
	
	jorge.modulate.a = 0.0
	name_t.modulate.a = 0.0
	overlay.hide()
	yield(get_tree().create_timer(18.5), "timeout")
	video.paused = true
	overlay.show()
	yield(get_tree().create_timer(0.2), "timeout")
	sfx.play()

func _process(_delta: float) -> void:
	if video.paused and jorge.modulate.a < 0.9:
		jorge.modulate.a += 0.1
		yield(get_tree().create_timer(1.0), "timeout")
		name_t.modulate.a += 0.1
		
	if jorge.modulate.a > 0.5 and jorge.rect_position.x < 366:
		jorge.rect_position.x += 10
		
	if name_t.modulate.a > 0.5 and name_t.rect_position.x > 936:
		name_t.rect_position.x -= 10
	
	if name_t.modulate.a > 0.9:
		yield(get_tree().create_timer(1.3), "timeout")
		for count in 5:
			yield(get_tree().create_timer(0.1), "timeout")
			array[count].show()
