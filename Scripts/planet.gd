extends Control

@onready var planet: AnimatedSprite2D = %Planet
@onready var explode_animation: AnimationPlayer = %ExplodeAnimation

signal explode_anim_finished()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode_animation.animation_finished.connect(_on_explode_finished)

func show_planet(current_planet: Dictionary):
	planet.play(current_planet.game_vars.anim_name)
	planet.modulate = Color(1, 1, 1, 1)
	planet.visible = true 

func hide_planet():
	planet.modulate = Color(1, 1, 1, 0)
	planet.visible = false

func play_explode():
	explode_animation.play("ExplodePlanet")

func _on_explode_finished(_anim):
	explode_anim_finished.emit(_anim)
