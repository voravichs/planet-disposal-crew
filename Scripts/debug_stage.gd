extends Node2D

@onready var ui_canvas_layer: CanvasLayer = $UICanvasLayer
@onready var w_arrow1 = %PlanetPointer1
@onready var w_arrow2 = %PlanetPointer2
@onready var w_arrow3 = %PlanetPointer3
@onready var w_arrow4 = %PlanetPointer4
@onready var b1: TextureButton = %B1
@onready var b2: TextureButton = %B2
@onready var b3: TextureButton = %B3
@onready var b4: TextureButton = %B4
@onready var space_planet_view: Control = %SpacePlanetView
@onready var console_planet: Sprite2D = %ConsolePlanet
@onready var gameplay_ui: Control = %GameplayUI
@onready var top_bar_info: MarginContainer = %TopBarInfo
@onready var console_info: Control = %ConsoleInfo
@onready var scan_button: Button = %ScanButton
@onready var crew_dialogue: Button = %CrewDialogue
@onready var decision_button: Button = %DecisionButton
@onready var decision_ui: Control = %DecisionUI
@onready var firing_ui: Control = %FiringUI
@onready var space: Control = %Space
@onready var planet_tracker = [b1, b2, b3, b4]
@onready var pointer_array = [w_arrow1, w_arrow2, w_arrow3, w_arrow4]

var current_planet_index: int = -1
var current_planet: Dictionary
var dialog_ui_reference: DialogUI
var planets_scanned = [false, false, false, false]

const DIALOGUE_FILE = "res://Dialogues/Debug.dialogue"
const BG_DANGER = preload("res://Assets/Themes/PanelContainer/bg_danger.tres")
const BG_PLAIN = preload("res://Assets/Themes/PanelContainer/bg_plain.tres")
const TOP_BG_DANGER = preload("res://Assets/Themes/PanelContainer/top_bg_danger.tres")
const TOP_BG_PLAIN = preload("res://Assets/Themes/PanelContainer/top_bg_plain.tres")
const DIALOG_UI = preload("res://Scenes/DialogUI.tscn")
const DEBUG_STAGE_DB_REF = preload("res://Scripts/StageParameters/debug_stage_db.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set initial planet pointer and set the planet
	_planet_tracker_pressed(current_planet_index)
	# Prevent button input
	disable_all_actions()
	# Init a debug DialogUI
	var debug_dialogue_resource = load(DIALOGUE_FILE)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(debug_dialogue_resource, "start")
	ui_canvas_layer.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_show_gameplay_ui)
	#DEBUG
	_show_gameplay_ui()
	space_planet_view.explode_anim_finished.connect(_on_explode_finished)
	space.ftl_finished.connect(set_planet)

# Called upon finishing FTL animation
# Sets the planet in space and in the console view
func set_planet():
	# Returns index to -1 after planet decision
	if (current_planet_index == -1):
		# hide all console info and disable actions
		console_info.hide_console_info()
		console_planet.visible = false
		disable_all_actions()
		return
	else:
		# Space
		current_planet = DEBUG_STAGE_DB_REF.PLANET_PARAMS[current_planet_index]
		space_planet_view.show_planet(current_planet)
		# Console
		console_planet.texture = load(current_planet.game_vars.spritesheet)
		console_planet.visible = true
		scan_button.text = "Scan ($" + str(current_planet.game_vars.scan_cost) + ")"
		# Enable actions
		enable_all_actions()
		# Sets console info and disables scans if already scanned
		if planets_scanned[current_planet_index]:
			scan_planet()

# Displays console info and disables the scan button
func scan_planet():
	console_info.set_console_info(current_planet)
	scan_button.disabled = true

# Enable all action buttons
func enable_all_actions():
	scan_button.disabled = false
	crew_dialogue.disabled = false
	decision_button.disabled = false

# Disable all action buttons
func disable_all_actions():
	scan_button.disabled = true
	crew_dialogue.disabled = true
	decision_button.disabled = true

# triggered upon clicking a planet on the tracker.
# takes in an int index as an argument, 
# and moves the pointer to that index and plays the animation
# Additionally also sets the planet
func _planet_tracker_pressed(index: int) -> void:
	# Prevent the same planet being pressed twice
	if (index >=0 && index < planets_scanned.size()) && (index == current_planet_index):
		print("unpog")
		return
	# Hide previous planet
	space_planet_view.hide_planet()
	# Hide console info
	console_info.hide_console_info()
	console_planet.visible = false
	# Set new planet index
	current_planet_index = index
	# Set the pointer in the gameplay UI
	for i in pointer_array.size():
		# Tracker index matches current index
		if index == i:
			# Show pointer animation and press the tracker button
			pointer_array[i].modulate = Color(1, 1, 1, 1) 
			pointer_array[i].play("pointer")
			planet_tracker[i].button_pressed = true
			# play FTL animation, prevent input during the process
			space.show_ftl()
			disable_all_actions()
		elif index == -1 || planet_tracker[i].disabled == false:
			pointer_array[i].modulate = Color(1, 1, 1, 0) 
			pointer_array[i].stop()

# sets the gameplay UI to visible, then removes the dialog UI from the tree
func _show_gameplay_ui():
	ui_canvas_layer.remove_child(dialog_ui_reference)
	gameplay_ui.visible = true

# explode the planet visually, then disable planet in tracker
func _explode_button() -> void:
	space_planet_view.play_explode()
	for i in planet_tracker.size():
		if current_planet_index == i:
			planet_tracker[i].disabled = true
			pointer_array[i].play("x")
	decision_button.disabled = true
	crew_dialogue.disabled = true
	decision_ui.visible = false
	firing_ui.visible = true
	firing_ui.play_anim()
	current_planet_index = -1
	set_planet()

func _on_explode_finished(_anim):
	print("pog")
	firing_ui.visible = false
	gameplay_ui.visible = true

# Scans the planet, then takes money out of the budget
func _on_scan_button_pressed() -> void:
	if !planets_scanned[current_planet_index]:
		scan_planet()
		planets_scanned[current_planet_index] = true
		GameVariables.money -= current_planet.game_vars.scan_cost
		top_bar_info.money_label.text = str(GameVariables.money)

# Change to dialogue mode
func _on_crew_dialogue_pressed() -> void:
	gameplay_ui.visible = false
	var debug_dialogue_resource = load(DIALOGUE_FILE)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(debug_dialogue_resource, current_planet.game_vars.dialogue)
	ui_canvas_layer.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_show_gameplay_ui)

func _on_decision_pressed() -> void:
	if planet_tracker[current_planet_index].disabled == false:
		gameplay_ui.visible = false
		decision_ui.visible = true

func _return() -> void:
	gameplay_ui.visible = true
	decision_ui.visible = false
