extends Control

var debug_stage = load("res://Scenes/debug_stage.tscn")

func _on_play_pressed() -> void:
	pass

func _on_debug_pressed() -> void:
	get_tree().change_scene_to_packed(debug_stage)

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
