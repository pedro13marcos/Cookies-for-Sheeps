extends Control

var isPaused = false;

func _ready() -> void:
	hide();
	
func _process(delta: float) -> void:
	
	if Input.is_action_just_released("Pause"):
		changePausedState();


func _on_continuar_button_up() -> void:
	changePausedState();
	
func _on_sair_button_up() -> void:
	get_tree().quit();


func _on_menu_button_up() -> void:
	changePausedState();
	get_tree().change_scene_to_file("res://nodes/menu.tscn");
	
func changePausedState():
	isPaused = !isPaused;
	if isPaused:
		get_tree().paused = true;
		show();
		$MarginContainer/VBoxContainer/Continuar.grab_focus();
	else:
		get_tree().paused = false;
		hide();
