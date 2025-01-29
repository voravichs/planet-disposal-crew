extends Node2D

@onready var ui_canvas_layer: CanvasLayer = $UICanvasLayer
@onready var debug_planet: AnimatedSprite2D = %DebugPlanet
@onready var debug_anim: AnimationPlayer = %DebugAnim
@onready var w_arrow1 = %PlanetPointer1
@onready var w_arrow2 = %PlanetPointer2
@onready var w_arrow3 = %PlanetPointer3
@onready var w_arrow4 = %PlanetPointer4
@onready var b1: TextureButton = %B1
@onready var b2: TextureButton = %B2
@onready var b3: TextureButton = %B3
@onready var b4: TextureButton = %B4
@onready var console_planet: Sprite2D = %ConsolePlanet
@onready var gameplay_ui: Control = %GameplayUI
@onready var console_info: Control = %ConsoleInfo
@onready var dialog_ui = preload("res://Scenes/DialogUI.tscn")

var rng = RandomNumberGenerator.new()
var current_planet_index: int = 1
var current_planet: Dictionary
var dialog_ui_reference: DialogUI
const debug_stage_db_ref = preload("res://Scripts/stage_parameter_db/debug_stage_db.gd")

const DIALOGUE_FILE = "res://Dialogues/Debug.dialogue"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Randomize Planets
	#rng.randomize()
	#randomize_planets(debug_planet, current_planet.game_vars.scale_factor)

	# Set initial planet pointer and set the planet
	_planet_tracker_pressed(current_planet_index)
	# Init a debug DialogUI
	var debug_dialogue_resource = load(DIALOGUE_FILE)
	dialog_ui_reference = dialog_ui.instantiate().with_data(debug_dialogue_resource)
	ui_canvas_layer.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_show_gameplay_ui)
	# DEBUG LINE TO LOOK AT GAMEPLAY UI
	_show_gameplay_ui()

# Randomize planet size
func randomize_planets(planet: AnimatedSprite2D, scale_factor: float):
	# Reset Scale first
	planet.scale = Vector2(1,1)
	# Randomize Scale and apply
	var rand = (rng.randf_range(0,1.5) + 1) * scale_factor
	planet.scale = Vector2(rand,rand)

# Sets the planet in space and in the console view
func set_planet():
	# Space
	current_planet = debug_stage_db_ref.PLANET_PARAMS[current_planet_index]
	debug_planet.play(current_planet.game_vars.anim_name)
	debug_planet.modulate = Color(1, 1, 1, 1) 
	# Console
	console_info.set_console_info(current_planet)

# triggered upon clicking a planet on the tracker.
# takes in an int index as an argument, 
# and moves the pointer to that index and plays the animation
# Additionally also sets the planet
func _planet_tracker_pressed(index: int) -> void:
	# stops the AnimationPlayer if it is still playing
	if debug_anim.is_playing():
		return
	# Set the planet in the space UI
	current_planet_index = index
	set_planet()
	# Set the pointer in the gameplay UI
	var planet_tracker = [b1, b2, b3, b4]
	var pointer_array = [w_arrow1, w_arrow2, w_arrow3, w_arrow4]
	for i in pointer_array.size():
		if index == i:
			pointer_array[i].modulate = Color(1, 1, 1, 1) 
			pointer_array[i].play("pointer")
			planet_tracker[i].button_pressed = true
		elif planet_tracker[i].disabled == false:
			pointer_array[i].modulate = Color(1, 1, 1, 0) 
			pointer_array[i].stop()

# sets the gameplay UI to visible, then removes the dialog UI from the tree
func _show_gameplay_ui():
	ui_canvas_layer.remove_child(dialog_ui_reference)
	gameplay_ui.visible = true

# explode the planet visually, then disable planet in tracker
func _explode_button() -> void:
	debug_anim.play("ExplodePlanet")
	var planet_tracker = [b1, b2, b3, b4]
	var pointer_array = [w_arrow1, w_arrow2, w_arrow3, w_arrow4]
	for i in planet_tracker.size():
		if current_planet_index == i:
			planet_tracker[i].disabled = true
			pointer_array[i].play("x")
