extends Area2D

#variaveis
var increment = 50;

#nodes
@onready var inimigo = get_node("../iniJoao");

#instrucoes de inicio
func _ready() -> void:
	position = inimigo.position;
	if self.is_in_group("pao") and has_node("Sprite2D"):
		$Sprite2D.texture = Global.get_ammo_texture();
	#OS.alert(name);

#colisao com o player
func _on_body_entered(body: Node2D) -> void:
	if body.name == "playerShak":
		if (self.is_in_group("pao")):
			body.speed += increment;
			body.addPao();
			queue_free();
		if (self.is_in_group("droga")):
			body.speed -= increment;
			queue_free();
	
