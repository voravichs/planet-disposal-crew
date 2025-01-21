extends Node2D

@onready var debug_planet: AnimatedSprite2D = $UICanvasLayer/Planet/DebugPlanet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_planet.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
