extends _old_character_base

onready var idle_anim = $Timer
onready var extra_anim = $AnimationPlayer

func _ready() -> void:
	idle_anim.start()

func _physics_process(_delta: float) -> void:
	if velocity >= Vector2(0.3, 0.3) or velocity <= Vector2(-0.3, -0.3):
		idle_anim.start()
		mock = false
		if extra_anim.is_playing():
			extra_anim.seek(0.0, true)
		extra_anim.stop()

func _on_Timer_timeout() -> void:
	mock = true
	anim.animation = "mock"
	extra_anim.play("mockText")

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	yield(get_tree().create_timer(1.2), "timeout")
	extra_anim.seek(0.0, true)
