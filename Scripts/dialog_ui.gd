extends Control

@onready var portrait: TextureRect = %Portrait
@onready var dialogue_line: DialogueLabel = %DialogueLine
@onready var dialogue_options: GridContainer = %DialogueOptions
@onready var choice_button_scn = preload("res://Scenes/ChoiceButton.tscn")

var animate_text : bool = false
var current_visible_chars : int = 0
var debug_dialogue_resource = load("res://Dialogues/Debug.dialogue")
var portrait_database_reference
var line : DialogueLine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Preload portrait database
	portrait_database_reference = preload("res://Scripts/portraits_db.gd")
	# Get the first line in the starting dialogue
	line = await debug_dialogue_resource.get_next_dialogue_line("start")
	# Set that line to the dialogue box and type it out
	process_dialogue()
	# clear any previous options
	clear_options()

func _input(event: InputEvent) -> void:
	if (line == null):
		return
	if event.is_action_pressed("next_line"):
		line = await debug_dialogue_resource.get_next_dialogue_line(line.next_id)
		if (line == null):
			dialogue_line.dialogue_line = line
			clear_options()
			return
		process_dialogue()
		if line.responses.size() > 0:
			dialogue_line.finished_typing.connect(_show_responses)

# Clear all previous options from the options container
func clear_options():
	var options_children = dialogue_options.get_children()
	for child in options_children:
		child.queue_free()

# sets the dialogue text to DialogueLine, and set the portrait
func process_dialogue():
	dialogue_line.dialogue_line = line
	dialogue_line.type_out()
	if !portrait_database_reference.PORTRAITS.has(line.character):
		printerr("Bad portrait_db key")
		return
	var portrait_index = portrait_database_reference.PORTRAITS[line.character]
	portrait.set_portrait(portrait_index)

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
	line = await debug_dialogue_resource.get_next_dialogue_line(line.responses[choice_index].next_id)
	if (line == null):
		dialogue_line.dialogue_line = line
		clear_options()
		return
	process_dialogue()
	if line.responses.size() > 0:
		dialogue_line.finished_typing.connect(_show_responses)
	clear_options()
