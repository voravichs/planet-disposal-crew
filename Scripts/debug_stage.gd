extends Node2D

@onready var debug_planet: AnimatedSprite2D = %DebugPlanet1
@onready var debug_planet2: AnimatedSprite2D = %DebugPlanet2
@onready var debug_planet3: AnimatedSprite2D = %DebugPlanet3
@onready var debug_planet4: AnimatedSprite2D = %DebugPlanet4
@onready var debug_anim: AnimationPlayer = %DebugAnim
@onready var dialog_ui = %DialogUI
@onready var b1 = %B1
@onready var b2 = %B2
@onready var b3 = %B3
@onready var b4 = %B4
@onready var w_arrow1 = %PlanetPointer1
@onready var w_arrow2 = %PlanetPointer2
@onready var w_arrow3 = %PlanetPointer3
@onready var w_arrow4 = %PlanetPointer4


var rng = RandomNumberGenerator.new()
var dialog_index : int = 0
const dialog_lines : Array[String] = [
	"AI: Pog pog lmao",
	"AI: 2",
	"AI: 3",
	"AI: 4"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Randomize Planets
	rng.randomize()
	randomize_planets(debug_planet, 1)
	randomize_planets(debug_planet2, 1)
	randomize_planets(debug_planet3, 1)
	randomize_planets(debug_planet4, 0.75)
	# Play animation for first planet
	debug_planet.play()
	# Set initial planet pointer
	_planet_tracker_pressed(0)

# Randomize planet size
func randomize_planets(planet: AnimatedSprite2D, scale_factor: float):
	var rand = (rng.randf_range(0,1.5) + 1) * scale_factor
	planet.scale = Vector2(rand,rand)

# triggered upon clicking a planet on the tracker.
# takes in an int index as an argument, 
# and moves the pointer to that index and plays the animation
# Additionally also sets the planet
func _planet_tracker_pressed(planet: int) -> void:
	var pointer_array = [w_arrow1, w_arrow2, w_arrow3, w_arrow4]
	var planet_array = [debug_planet, debug_planet2, debug_planet3, debug_planet4]
	for i in pointer_array.size():
		if planet == i:
			pointer_array[i].modulate = Color(1, 1, 1, 1) 
			pointer_array[i].play()
			planet_array[i].visible = true
			planet_array[i].play()
		else:
			pointer_array[i].modulate = Color(1, 1, 1, 0) 
			pointer_array[i].stop()
			planet_array[i].visible = false
			planet_array[i].stop()


func _explode_button(planet: int) -> void:
	match planet:
		0:
			debug_anim.play("ExplodePlanet1")
		1:
			debug_anim.play("ExplodePlanet2")
		2:
			debug_anim.play("ExplodePlanet3")
		3:
			debug_anim.play("ExplodePlanet4")
