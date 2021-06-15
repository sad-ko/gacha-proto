tool
extends Sprite

func _process(_delta: float) -> void:
	_zoom_changed()

func _zoom_changed():
	material.set_shader_param("y_zoom", get_viewport().global_canvas_transform.y.y)

func _on_Water_item_rect_changed() -> void:
	material.set_shader_param("scale", scale)
