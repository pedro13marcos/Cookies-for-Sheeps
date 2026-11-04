extends Node2D

func _ready() -> void:
	Global.currentLevel = scene_file_path;
	Global.save_game();

func goNextLevel():
	get_tree().change_scene_to_file("res://nodes/level3.tscn");
