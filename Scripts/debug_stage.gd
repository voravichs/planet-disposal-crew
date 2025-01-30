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
@onready var money_label: RichTextLabel = %MoneyLabel
@onready var scan_button: Button = %ScanButton
@onready var crew_dialogue: Button = %CrewDialogue
@onready var decision_button: Button = %DecisionButton
@onready var console_bg: PanelContainer = %ConsoleBG
@onready var console_bg_top: PanelContainer = %ConsoleBGTop
@onready var decision_ui: Control = %DecisionUI

var rng = RandomNumberGenerator.new()
var current_planet_index: int = 0
var current_planet: Dictionary
var dialog_ui_reference: DialogUI
var planets_scanned = [false, false, false, false]

const DIALOGUE_FILE = "res://Dialogues/Debug.dialogue"
const BG_DANGER = preload("res://Assets/Themes/PanelContainer/bg_danger.tres")
const BG_PLAIN = preload("res://Assets/Themes/PanelContainer/bg_plain.tres")
const TOP_BG_DANGER = preload("res://Assets/Themes/PanelContainer/top_bg_danger.tres")
const TOP_BG_PLAIN = preload("res://Assets/Themes/PanelContainer/top_bg_plain.tres")
const DIALOG_UI = preload("res://Scenes/DialogUI.tscn")
const DEBUG_STAGE_DB_REF = preload("res://Scripts/state_parameter_db/debug_stage_db.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set initial planet pointer and set the planet
	_planet_tracker_pressed(current_planet_index)
	# Set initial money
	money_label.text = str(GameVariables.money)
	# Init a debug DialogUI
	var debug_dialogue_resource = load(DIALOGUE_FILE)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(debug_dialogue_resource, "start")
	ui_canvas_layer.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_show_gameplay_ui)
	#DEBUG
	_show_gameplay_ui()

# Sets the planet in space and in the console view
func set_planet():
	# Space
	current_planet = DEBUG_STAGE_DB_REF.PLANET_PARAMS[current_planet_index]
	debug_planet.play(current_planet.game_vars.anim_name)
	debug_planet.modulate = Color(1, 1, 1, 1) 
	# Console
	console_planet.texture = load(current_planet.game_vars.spritesheet)
	scan_button.text = "Scan ($" + str(current_planet.game_vars.scan_cost) + ")"

func scan_planet():
	console_info.set_console_info(current_planet)
	scan_button.disabled = true

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
			if planets_scanned[i]:
				scan_planet()
			else:
				console_info.hide_console_info()
				scan_button.disabled = false
		elif planet_tracker[i].disabled == false:
			pointer_array[i].modulate = Color(1, 1, 1, 0) 
			pointer_array[i].stop()
			decision_button.disabled = false
			crew_dialogue.disabled = false

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
			decision_button.disabled = true
			crew_dialogue.disabled = true
			_return()

# Scans the planet, then takes money out of the budget
func _on_scan_button_pressed() -> void:
	if !planets_scanned[current_planet_index]:
		scan_planet()
		planets_scanned[current_planet_index] = true
		GameVariables.money -= current_planet.game_vars.scan_cost
		money_label.text = str(GameVariables.money)

# Change to dialogue mode
func _on_crew_dialogue_pressed() -> void:
	gameplay_ui.visible = false
	var debug_dialogue_resource = load(DIALOGUE_FILE)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(debug_dialogue_resource, current_planet.game_vars.dialogue)
	ui_canvas_layer.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_show_gameplay_ui)

func _on_decision_pressed() -> void:
	var planet_tracker = [b1, b2, b3, b4]
	if planet_tracker[current_planet_index].disabled == false:
		gameplay_ui.visible = false
		decision_ui.visible = true

func _return() -> void:
	gameplay_ui.visible = true
	decision_ui.visible = false
