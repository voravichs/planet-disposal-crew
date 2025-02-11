extends Node2D

@onready var animations: AnimationPlayer = %Animations
@onready var command_line: RichTextLabel = %CommandLine
@onready var dialog_ui: DialogUI = %DialogUI
@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var click: Control = $CanvasLayer/Click
@onready var input: VBoxContainer = %Input
@onready var name_input: LineEdit = %NameInput
@onready var pronouns: OptionButton = %Pronouns

var dialog_ui_reference: DialogUI
var wait_click: bool = false
var custom_pronoun

const DIALOG_RESOURCE = preload(DIALOGUE_FILE)
const DIALOGUE_FILE = "res://Dialogues/Intro.dialogue"
const DIALOG_UI = preload("res://Scenes/dialog_ui_intro.tscn")
const DEBUG_STAGE = preload("res://Scenes/debug_stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animations.play("DEBUG")
	animations.animation_finished.connect(_wait_input)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(DIALOG_RESOURCE, "post_input")
	#dialog_ui_reference.finished_dialogue.connect(_input_name)
	dialog_ui_reference.finished_dialogue.connect(_next_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dialogic_default_action") && wait_click:
		wait_click = false
		click.visible = false
		play_intro_dialogue()

func _wait_input(_anim):
	wait_click = true
	click.visible = true

func play_intro_dialogue():
	canvas_layer.add_child(dialog_ui_reference)
	command_line.visible = false

func _input_name():
	canvas_layer.remove_child(dialog_ui_reference)
	input.visible = true

func _on_confirm_pressed() -> void:
	var pronouns_list = pronouns.get_item_text(pronouns.selected).split("/")
	GameVariables.ai_name = name_input.text
	GameVariables.ai_pronouns.subj = pronouns_list[0]
	GameVariables.ai_pronouns.obj = pronouns_list[1]
	GameVariables.ai_pronouns.poss = pronouns_list[2]
	if pronouns_list[0] == "they":
		GameVariables.ai_pronouns.linking = "are"
	else:
		GameVariables.ai_pronouns.linking = "is"
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(DIALOG_RESOURCE, "post_input")
	dialog_ui_reference.finished_dialogue.connect(_next_scene)
	canvas_layer.add_child(dialog_ui_reference)
	input.visible = false

func _next_scene():
	get_tree().change_scene_to_packed(DEBUG_STAGE)
