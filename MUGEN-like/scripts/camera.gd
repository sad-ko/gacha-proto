extends Camera2D

var zoomOut : bool = false

func _process(delta: float) -> void:
	if zoomOut and zoom < Vector2(0.6, 0.6):
		zoom += Vector2(0.05, 0.05)
	
	if zoom >= Vector2(0.6, 0.6):
		zoomOut = false
	
	if not zoomOut and zoom < Vector2(0.4, 0.4):
		zoom -= Vector2(0.05, 0.05)
	
func _on_VisibilityNotifier2D_screen_exited() -> void:
	zoomOut = true
