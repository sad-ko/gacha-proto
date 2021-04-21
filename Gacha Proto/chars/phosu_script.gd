extends Node

var stars = 3
var char_name = "Phosu"
onready var png = $PNG
onready var overlay = $Overlay

func _ready():
	png.modulate.a = 0.0
	overlay.modulate.a = 0.0
