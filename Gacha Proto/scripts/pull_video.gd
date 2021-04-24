extends Node

var show_effect = 0.0
var pos = 50
var done_stars = false
var count = 0
var timer

onready var Pull = $Pull
onready var video = $VideoPlayer
onready var name_t = $Label
onready var overlay = $ColorRect
onready var sfx = $AudioStreamPlayer
onready var back_button = $Back

onready var star1 = $Stars/Star
onready var star2 = $Stars/Star2
onready var star3 = $Stars/Star3
onready var star4 = $Stars/Star4
onready var star5 = $Stars/Star5

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
	
	name_t.modulate.a = 0.0
	overlay.hide()
	back_button.hide()
	yield(get_tree().create_timer(18.5), "timeout")
	video.paused = true
	overlay.show()
	sfx.play()
	$Timer.start()

func _process(_delta: float) -> void:
	if video.paused:
		var delay = visuals()
		if delay:
			back_button.show()
			$Stars/StarsTimer.start()

func visuals() -> int:
	if show_effect < 1.0:
		show_effect += 0.01
		Pull.effect(show_effect)
	
	if name_t.modulate.a < 1.0:
		name_t.modulate.a += 0.1
	
	if show_effect > 0.2 and pos < 180:
		Pull.slide()
		pos += 5
	
	if name_t.modulate.a > 0.5 and name_t.rect_position.x > 936:
		name_t.rect_position.x -= 5
	
	return 1

func _on_Timer_timeout() -> void:
	set_process(false)

func _on_StarsTimer_timeout() -> void:
	$Stars/StarsTimer/StarsTimer2.start()

func _on_StarsTimer2_timeout() -> void:
	if count < Pull.char_id[Pull.roll].stars:
		array[count].show()
		count += 1
