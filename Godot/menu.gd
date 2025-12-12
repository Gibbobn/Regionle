extends Node3D

func _on_button_pressed():
	Global.daily = true
	get_tree().change_scene_to_file("res://Daily.tscn")

func _on_practice_pressed() -> void:
	Global.daily = false
	get_tree().change_scene_to_file("res://Daily.tscn")
	
