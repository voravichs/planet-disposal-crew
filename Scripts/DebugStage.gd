extends Node2D

@onready var debug_planet = %DebugPlanet
@onready var debug_planet2 = %DebugPlanet2
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
var current_planet : int = 1

const dialog_lines : Array[String] = [
	"AI: Pog pog lmao",
	"AI: 2",
	"AI: 3",
	"AI: 4"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play planet animation
	debug_planet.play()
	debug_planet2.play()
	b1.pressed.connect(self._button_pressed1)
	b2.pressed.connect(self._button_pressed2)
	b3.pressed.connect(self._button_pressed3)
	b4.pressed.connect(self._button_pressed4)
	# Process first line of dialog
	dialog_index = 0
	process_current_line()
	# Set initial planet pointer
	current_planet = 1
	set_planet_pointer_on_tracker()

func _button_pressed1():
	w_arrow1.modulate = Color(1, 1, 1, 1) 
	w_arrow2.modulate = Color(1, 1, 1, 0) 
	w_arrow3.modulate = Color(1, 1, 1, 0) 
	w_arrow4.modulate = Color(1, 1, 1, 0) 
	
func _button_pressed2():
	w_arrow1.modulate = Color(1, 1, 1, 0) 
	w_arrow2.modulate = Color(1, 1, 1, 1) 
	w_arrow3.modulate = Color(1, 1, 1, 0) 
	w_arrow4.modulate = Color(1, 1, 1, 0) 

func _button_pressed3():
	w_arrow1.modulate = Color(1, 1, 1, 0) 
	w_arrow2.modulate = Color(1, 1, 1, 0) 
	w_arrow3.modulate = Color(1, 1, 1, 1) 
	w_arrow4.modulate = Color(1, 1, 1, 0) 

func _button_pressed4():
	w_arrow1.modulate = Color(1, 1, 1, 0) 
	w_arrow2.modulate = Color(1, 1, 1, 0) 
	w_arrow3.modulate = Color(1, 1, 1, 0) 
	w_arrow4.modulate = Color(1, 1, 1, 1) 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		if dialog_index < len(dialog_lines) - 1:
			dialog_index += 1
			process_current_line()

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

# Sets the UI component for the pointer to the planet on the tracker
func set_planet_pointer_on_tracker():
	pass
