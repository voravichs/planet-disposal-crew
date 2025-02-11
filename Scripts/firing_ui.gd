extends Control
@onready var console_danger_anim: AnimationPlayer = %ConsoleDangerAnim

func play_anim():
	console_danger_anim.play("danger")
