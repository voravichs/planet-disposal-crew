extends Control

func _on_play_pressed() -> void:
	pass

func _on_debug_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DebugStage.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
