extends Control

@onready var dialogue_line = %DialogueLine
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
	change_line()

func _input(event: InputEvent) -> void:
	if (line == null):
		return
	if event.is_action_pressed("next_line"):
		line = await resource.get_next_dialogue_line(line.next_id)
		if (line == null):
			change_line()
			clear_options()
			return
		if line.responses.size() > 0:
			change_line_and_show_responses()
		else:
			change_line()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animate_text:
		if dialogue_line.visible_ratio < 1:
			dialogue_line.visible_ratio += (1.0/dialogue_line.text.length()) * (ANIMATION_SPEED * delta)
			current_visible_chars = dialogue_line.visible_characters
		else:
			animate_text = false

func clear_options():
	var options_children = dialogue_options.get_children()
	for child in options_children:
		child.queue_free()

# Changes line of dialogue and scrolls it
func change_line():
	var str_line: String = ""
	if line != null:
		str_line = line.character + ": " + line.text
	current_visible_chars = 0
	dialogue_line.visible_characters = 0
	dialogue_line.text = str_line
	animate_text = true

# Changes the line and shows the responses in a formatted way
func change_line_and_show_responses():
	var str_line: String = line.character + ": " + line.text + "\n"
	for i in range(line.responses.size()):
		var btn_obj: ChoiceButton = choice_button_scn.instantiate()
		btn_obj.choice_index = i
		btn_obj.text = line.responses[i].text
		btn_obj.choice_selected.connect(_on_choice_selected)
		dialogue_options.add_child(btn_obj)
	current_visible_chars = 0
	dialogue_line.visible_characters = 0
	dialogue_line.text = str_line
	animate_text = true

# Called when a dialogue choice is selected
func _on_choice_selected(choice_index: int):
	line = await resource.get_next_dialogue_line(line.responses[choice_index].next_id)
	if (line == null):
		change_line()
		clear_options()
		return
	if line.responses.size() > 0:
		change_line_and_show_responses()
	else:
		change_line()
	clear_options()
