extends CanvasLayer


func _on_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://nodes/menu.tscn");


func _on_sair_button_up() -> void:
	get_tree().quit();
