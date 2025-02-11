extends MarginContainer

@onready var money_label: RichTextLabel = %MoneyLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set initial money
	money_label.text = str(GameVariables.money)
