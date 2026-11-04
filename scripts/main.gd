extends Node2D

func _process(delta: float) -> void:
	print(Input.get_joy_info(0));
	pass;

func goNextLevel():
	OS.alert("passou de fase");
