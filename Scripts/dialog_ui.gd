extends Control

@onready var dialogue_line: DialogueLabel = %DialogueLine
@onready var dialogue_options: GridContainer = %DialogueOptions
@onready var choice_button_scn = preload("res://Scenes/ChoiceButton.tscn")

const ANIMATION_SPEED : int = 30

var animate_text : bool = false
var current_visible_chars : int = 0
var resource = load("res://Dialogues/Debug.dialogue")
var line : DialogueLine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line = await resource.get_next_dialogue_line("start")
	clear_options()
	#change_line()
	dialogue_line.dialogue_line = line
	dialogue_line.type_out()

func _input(event: InputEvent) -> void:
	if (line == null):
		return
	if event.is_action_pressed("next_line"):
		line = await resource.get_next_dialogue_line(line.next_id)
		if (line == null):
			dialogue_line.dialogue_line = line
			clear_options()
			return
		dialogue_line.dialogue_line = line
		dialogue_line.type_out()
		if line.responses.size() > 0:
			dialogue_line.finished_typing.connect(_show_responses)

func clear_options():
	var options_children = dialogue_options.get_children()
	for child in options_children:
		child.queue_free()

# Changes the line and shows the responses in a formatted way
func _show_responses():
	for i in range(line.responses.size()):
		var btn_obj: ChoiceButton = choice_button_scn.instantiate()
		btn_obj.choice_index = i
		btn_obj.text = line.responses[i].text
		btn_obj.choice_selected.connect(_on_choice_selected)
		dialogue_options.add_child(btn_obj)

# Called when a dialogue choice is selected
func _on_choice_selected(choice_index: int):
	line = await resource.get_next_dialogue_line(line.responses[choice_index].next_id)
	if (line == null):
		dialogue_line.dialogue_line = line
		clear_options()
		return
	dialogue_line.dialogue_line = line
	dialogue_line.type_out()
	if line.responses.size() > 0:
		dialogue_line.finished_typing.connect(_show_responses)
	clear_options()
