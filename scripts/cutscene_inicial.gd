extends Control

func _ready() -> void:
	$cutsceneMenu.hide();
	$AnimationPlayer.play("cutscene");
	
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		pularCutscene();

func pularCutscene():
	get_tree().paused = true;
	$cutsceneMenu.show();
	$cutsceneMenu/VBoxContainer/Continuar.grab_focus();
	

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://nodes/level1.tscn");


func _on_continuar_button_up() -> void:
	get_tree().paused = false;
	$cutsceneMenu.hide();
	


func _on_pular_button_up() -> void:
	$AnimationPlayer.stop();
	get_tree().paused = false;
	_on_animation_player_animation_finished("custscene");


func _on_menu_button_up() -> void:
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://nodes/menu.tscn");


func _on_sair_button_up() -> void:
	get_tree().quit();
