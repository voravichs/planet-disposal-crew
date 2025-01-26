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

var dialog_index : int = 0
var rng = RandomNumberGenerator.new()
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
	# Process first line of dialog
	dialog_index = 0
	process_current_line()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		if dialog_index < len(dialog_lines) - 1:
			dialog_index += 1
			process_current_line()

# Randomize planet size
func randomize_planets(planet: AnimatedSprite2D, scale_factor: float):
	var rand = (rng.randf_range(0,1.5) + 1) * scale_factor
	planet.scale = Vector2(rand,rand)

# Splits line into speaker and dialog
func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	return {
		"speaker": line_info[0],
		"dialog_line": line_info[1]
	}

# Sets dialog in UI
func process_current_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	dialog_ui.change_line(line_info["speaker"] + ": " + line_info["dialog_line"])

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
