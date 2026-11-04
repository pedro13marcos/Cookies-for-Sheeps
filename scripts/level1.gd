extends Node2D

var keyPressed = false;

func _ready() -> void:
	Global.vidas  = 3;
	Global.prevScenePath = "res://nodes/level2.tscn";
	$Tutorial.show();
	$"Tutorial/TextureRect/VBoxContainer/HBoxContainer/1".show();
	$"Tutorial/TextureRect/VBoxContainer/HBoxContainer/2".hide();
	get_tree().paused=true;

func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		if keyPressed == false:
			keyPressed = true;
			$Tutorial/keyCoolDown.start(2);
			if $"Tutorial/TextureRect/VBoxContainer/HBoxContainer/1".is_visible_in_tree():
				$"Tutorial/TextureRect/VBoxContainer/HBoxContainer/1".hide();
				$"Tutorial/TextureRect/VBoxContainer/HBoxContainer/2".show();
			else: if $"Tutorial/TextureRect/VBoxContainer/HBoxContainer/2".is_visible_in_tree():
				$Tutorial.hide();
				get_tree().paused = false;

func goNextLevel():
	get_tree().change_scene_to_file(Global.prevScenePath);


func _on_key_cool_down_timeout() -> void:
	keyPressed = false;
