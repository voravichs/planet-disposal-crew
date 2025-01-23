extends Control

@onready var dialog_line = %DialogLine

const ANIMATION_SPEED : int = 20

var animate_text : bool = false
var current_visible_chars : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/dialog_line.text.length()) * (ANIMATION_SPEED * delta)
			current_visible_chars = dialog_line.visible_characters
		else:
			animate_text = false

# Changes line of dialogue and scrolls it
func change_line(line: String):
	current_visible_chars = 0
	dialog_line.visible_characters = 0
	dialog_line.text = line
	animate_text = true
